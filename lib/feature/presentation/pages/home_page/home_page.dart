import 'package:borgo/core/utils/app_colors.dart';
import 'package:borgo/feature/data/datasources/db_service.dart';
import 'package:borgo/feature/presentation/controllers/home_controller.dart';
import 'package:borgo/feature/presentation/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Container(
          color: AppColors.bgColor,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.bgColor,
              body: controller.isLoading
                  ? WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: LoadingPage())
                  : WillPopScope(
                      onWillPop: () async {
                        if (controller.controller != null) {
                          bool canGoBack =
                              await controller.controller!.canGoBack();
                          if (canGoBack) {
                            await controller.controller!.goBack();
                            return false;
                          }
                        }
                        return false;
                      },
                      child: Stack(
                        children: [
                          InAppWebView(
                            initialSettings: InAppWebViewSettings(
                              disableContextMenu:
                                  true, // Отключает контекстное меню
                              javaScriptEnabled: true, // Включает JS
                              clearCache: true,
                            ),

                            key: ValueKey('InAppWebViewKey'),
                            initialUrlRequest:
                                URLRequest(url: WebUri(controller.loginUrl)),
                            initialOptions: InAppWebViewGroupOptions(
                              crossPlatform: InAppWebViewOptions(
                                javaScriptEnabled: true,
                                useShouldOverrideUrlLoading: true,
                                supportZoom: false,
                              ),
                            ),

                            onWebViewCreated: (InAppWebViewController
                                webViewController) async {
                              controller.controller = webViewController;
                              controller.change2(true);
                            },
                            onTitleChanged: (controlle, title) async {
                              if (title == 'BORGO.UZ - Kirish') {
                                await controller.changeLogin(false);
                                controller.changeTokens();
                              }
                              if (title == 'BORGO.UZ - Dashboard' &&
                                  !controller.loginData) {
                                //LOGIN BOGANDA

                                final localStorage =
                                    await controller.getLocalStorage(controlle);
                                if (localStorage == null) {
                                  return;
                                }
                                controller.getRefreshToken(localStorage);

                                await controller.changeLogin(true);
                              }
                            },
                            onUpdateVisitedHistory:
                                (controlle, url, isReload) async {},
                            onLoadStop:
                                (InAppWebViewController webViewController,
                                    Uri? url) async {
                              if (url.toString() ==
                                      controller.loginUrl.toString() &&
                                  controller.access != null &&
                                  controller.refres != null &&
                                  controller.isFirstOpen) {
                                await webViewController
                                    .evaluateJavascript(source: """
                                      localStorage.setItem('AuthTokenBorgoUser', JSON.stringify({
                                        "access": "${controller.access}",
                                        "refresh": "${controller.refres}"
                                      }));
                                    """);
                                await DBService.to.changeLogin(true);
                                await webViewController.reload();
                                controller.changeFirst(false);
                                return;
                              }
                              if (controller.isFirstOpen) {
                                controller.changeFirst(false);
                                controller.change2(false);
                              }
                            },
                            onProgressChanged: (controlle, progress) {
                              if (progress == 100) {
                                if (controller.isLoading2 &&
                                    !controller.isFirstOpen) {
                                  controller.change2(false);
                                }
                              }
                            },

                            //URL_LAUNCHER
                            shouldOverrideUrlLoading:
                                (controlle, navigationAction) async {
                              Uri uri = navigationAction.request.url!;

                              // WHATSAPP
                              if (uri.toString().contains('api.whatsapp.com')) {
                                try {
                                  final text =
                                      uri.queryParameters['text'] ?? '';
                                  final encodedText = Uri.encodeComponent(text);
                                  final whatsappUrl = Uri.parse(
                                      'whatsapp://send?text=$encodedText');

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
                                  final path = uri.pathSegments.isNotEmpty
                                      ? uri.pathSegments.first
                                      : '';
                                  final queryParams = uri.queryParameters;

                                  if (path.startsWith('+') ||
                                      RegExp(r'^\d+$').hasMatch(path)) {
                                    final telegramAccountUri =
                                        Uri.parse('tg://resolve?domain=$path');

                                    if (await canLaunchUrl(
                                        telegramAccountUri)) {
                                      await launchUrl(telegramAccountUri,
                                          mode: LaunchMode
                                              .externalNonBrowserApplication);
                                      return NavigationActionPolicy.CANCEL;
                                    }
                                  } else {
                                    final productUrl = queryParams['url'] ?? '';
                                    final text = queryParams['text'] ?? '';

                                    if (productUrl.isNotEmpty ||
                                        text.isNotEmpty) {
                                      final telegramShareUri = Uri.parse(
                                          'tg://msg?url=${Uri.encodeComponent(productUrl)}&text=${Uri.encodeComponent(text)}');

                                      if (await canLaunchUrl(
                                          telegramShareUri)) {
                                        await launchUrl(telegramShareUri,
                                            mode:
                                                LaunchMode.externalApplication);
                                        return NavigationActionPolicy.CANCEL;
                                      }
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri,
                                            mode:
                                                LaunchMode.externalApplication);
                                      }
                                    }
                                  }
                                } catch (e) {
                                  return NavigationActionPolicy.CANCEL;
                                }
                                return NavigationActionPolicy.CANCEL;
                              }

                              if (controller.externalSchemes
                                      .contains(uri.scheme) ||
                                  controller.externalDomains.any(
                                      (domain) => uri.host.contains(domain))) {
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
                          controller.isLoading2 ? LoadingPage() : SizedBox(),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
