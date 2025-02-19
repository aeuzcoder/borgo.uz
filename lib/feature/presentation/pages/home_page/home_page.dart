import 'package:borgo/core/utils/app_colors.dart';
import 'package:borgo/feature/data/datasources/db_service.dart';
import 'package:borgo/feature/presentation/controllers/home_controller.dart';
import 'package:borgo/feature/presentation/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InAppWebViewController? webcontroller;
  GlobalKey webViewKey = GlobalKey();

  @override
  void dispose() {
    webcontroller?.dispose();
    webcontroller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Container(
      color: AppColors.bgColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.bgColor,
          body: WillPopScope(
            onWillPop: () async {
              if (webcontroller != null && await webcontroller!.canGoBack()) {
                await webcontroller!.goBack();
                return false;
              }
              return false;
            },
            child: Stack(
              children: [
                InAppWebView(
                  key: UniqueKey(),
                  initialSettings: InAppWebViewSettings(
                    disableContextMenu: true,
                    javaScriptEnabled: true,
                    clearCache: true,
                  ),
                  initialUrlRequest:
                      URLRequest(url: WebUri(controller.loginUrl)),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      javaScriptEnabled: true,
                      useShouldOverrideUrlLoading: true,
                      supportZoom: false,
                    ),
                  ),
                  onWebViewCreated: (webViewController) {
                    if (webcontroller == null) {
                      webcontroller = webViewController;
                      controller.change2(true);
                    }
                  },
                  onTitleChanged: (controlle, title) async {
                    if (title == 'BORGO.UZ - Kirish') {
                      await controller.changeLogin(false);
                      controller.changeTokens();
                    } else if (title == 'BORGO.UZ - Dashboard' &&
                        !controller.loginData) {
                      final localStorage =
                          await controller.getLocalStorage(controlle);
                      if (localStorage != null) {
                        await controller.getRefreshToken(localStorage);
                        await controller.changeLogin(true);
                      }
                    } else if (title == 'BORGO.UZ - E\'lon yaratish' &&
                        controller.loginData) {
                      final status = await Permission.camera.request();
                      if (status.isDenied) {
                        debugPrint("Доступ к камере запрещён!");
                        return;
                      }

                      if (status.isPermanentlyDenied) {
                        return;
                      }
                      if (status.isGranted) {
                        return;
                      }
                    }
                  },
                  onLoadStop: (webViewController, url) async {
                    if (url.toString() == controller.loginUrl &&
                        controller.access != null &&
                        controller.refres != null &&
                        controller.isFirstOpen) {
                      await webViewController.evaluateJavascript(source: """
                                  localStorage.setItem('AuthTokenBorgoUser', JSON.stringify({
                                    "access": "${controller.access}",
                                    "refresh": "${controller.refres}"
                                  }));
                                window.location.href = window.location.href;
                                """);
                      await DBService.to.changeLogin(true);
                      //await webViewController.reload();
                      controller.changeFirst(false);

                      return;
                    }
                    if (controller.isFirstOpen) {
                      controller.changeFirst(false);
                      controller.change2(false);
                    }
                  },
                  onProgressChanged: (_, progress) {
                    if (progress == 100 &&
                        controller.isLoading2 &&
                        !controller.isFirstOpen) {
                      controller.change2(false);
                    }
                  },
                  //URL_LAUNCHER
                  shouldOverrideUrlLoading:
                      (controlle, navigationAction) async {
                    Uri uri = navigationAction.request.url!;

                    // WHATSAPP
                    if (uri.toString().contains('api.whatsapp.com')) {
                      try {
                        final text = uri.queryParameters['text'] ?? '';
                        final encodedText = Uri.encodeComponent(text);
                        final whatsappUrl =
                            Uri.parse('whatsapp://send?text=$encodedText');

                        if (await canLaunchUrl(whatsappUrl)) {
                          await launchUrl(whatsappUrl,
                              mode: LaunchMode.externalApplication);

                          // 🛑 Останавливаем загрузку WebView
                          return NavigationActionPolicy.CANCEL;
                        } else {
                          final fallbackUrl = Uri.parse(
                              'https://api.whatsapp.com/send?text=$encodedText');

                          if (await canLaunchUrl(fallbackUrl)) {
                            await launchUrl(fallbackUrl,
                                mode: LaunchMode.externalApplication);
                            return NavigationActionPolicy.CANCEL;
                          }
                        }
                      } catch (e) {
                        return NavigationActionPolicy.CANCEL;
                      }
                      return NavigationActionPolicy.CANCEL;
                    }

                    //TELEGRAM

                    if (uri.scheme == 'tg' ||
                        uri.host == 'telegram.me' ||
                        uri.host == 't.me') {
                      try {
                        debugPrint('⚡ Переход по ссылке: $uri');
                        final path = uri.pathSegments.isNotEmpty
                            ? uri.pathSegments.first
                            : '';
                        final queryParams = uri.queryParameters;

                        if (path.startsWith('+') ||
                            RegExp(r'^\d+$').hasMatch(path)) {
                          final telegramAccountUri =
                              Uri.parse('tg://resolve?domain=$path');

                          if (await canLaunchUrl(telegramAccountUri)) {
                            await launchUrl(telegramAccountUri,
                                mode: LaunchMode.externalNonBrowserApplication);
                            return NavigationActionPolicy.CANCEL;
                          }
                        } else {
                          final productUrl = queryParams['url'] ?? '';
                          final text = queryParams['text'] ?? '';

                          if (productUrl.isNotEmpty || text.isNotEmpty) {
                            final telegramShareUri = Uri.parse(
                                'tg://msg?url=${Uri.encodeComponent(productUrl)}&text=${Uri.encodeComponent(text)}');

                            if (await canLaunchUrl(telegramShareUri)) {
                              await launchUrl(telegramShareUri,
                                  mode: LaunchMode.externalApplication);
                              return NavigationActionPolicy.CANCEL;
                            }
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                              return NavigationActionPolicy.CANCEL;
                            }
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              // Попробуем открыть ссылку через браузер
                              await launchUrl(uri,
                                  mode: LaunchMode.platformDefault);
                              return NavigationActionPolicy.CANCEL;
                            }
                          }
                        }
                      } catch (e) {
                        return NavigationActionPolicy.CANCEL;
                      }
                      return NavigationActionPolicy.CANCEL;
                    }

                    if (controller.externalSchemes.contains(uri.scheme) ||
                        controller.externalDomains
                            .any((domain) => uri.host.contains(domain))) {
                      try {
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                          return NavigationActionPolicy.CANCEL;
                        }
                      } catch (e) {
                        return NavigationActionPolicy.CANCEL;
                      }
                      return NavigationActionPolicy.CANCEL;
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                ),
                GetBuilder<HomeController>(builder: (controller) {
                  return controller.isLoading2 || controller.isLoading
                      ? WillPopScope(
                          onWillPop: () async => false,
                          child: LoadingPage(),
                        )
                      : SizedBox();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
