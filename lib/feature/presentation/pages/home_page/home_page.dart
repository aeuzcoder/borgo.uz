import 'dart:developer';

import 'package:borgo/core/utils/app_colors.dart';
import 'package:borgo/feature/presentation/controllers/home_controller.dart';
import 'package:borgo/feature/presentation/pages/loading_page.dart';
import 'package:borgo/feature/presentation/pages/login_page/login_page.dart';
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
                            onUpdateVisitedHistory:
                                (controlle, url, isReload) async {
                              if (url.toString().contains('borgo.uz/login')) {
                                await controller.delFirst();
                                Get.offAll(() => LoginPage());
                              }
                            },
                            onLoadStop:
                                (InAppWebViewController webViewController,
                                    Uri? url) async {
                              if (url.toString() ==
                                      controller.loginUrl.toString() &&
                                  controller.isFirstOpen) {
                                await webViewController
                                    .evaluateJavascript(source: """
                                      localStorage.setItem('AuthTokenBorgoUser', JSON.stringify({
                                        "access": "${controller.access}",
                                        "refresh": "${controller.refres}"
                                      }));
                                    """);
                                log('TOKEN YOZILDI');
                                await webViewController.reload();
                                await controller.setFirst(false);
                              }
                            },
                            onProgressChanged: (controlle, progress) {
                              log('PROGRESSSSS: $progress');
                              if (progress == 100) {
                                if (controller.isLoading2 &&
                                    !controller.isFirstOpen) {
                                  controller.change2(false);
                                }
                              }
                            },
                            shouldOverrideUrlLoading:
                                (controller, navigationAction) async {
                              Uri uri = navigationAction.request.url!;
                              log('🔍 Запрос на переход: ${uri.toString()}');

                              List<String> externalSchemes = [
                                'tel',
                                'mailto',
                                'tg',
                                'whatsapp',
                                'vk',
                                'viber',
                                'instagram',
                                'facebook',
                                'skype'
                              ];

                              List<String> externalDomains = [
                                'vk.com',
                                'twitter.com',
                                'instagram.com',
                                'facebook.com',
                                'linkedin.com',
                              ];
                              // Обработка WhatsApp-ссылок
                              if (uri.scheme == 'whatsapp') {
                                try {
                                  // Проверяем, установлен ли WhatsApp
                                  final whatsappUrl = Uri.parse(
                                      'whatsapp://send?text=${uri.queryParameters['text']}');
                                  if (await canLaunchUrl(whatsappUrl)) {
                                    // Если WhatsApp установлен, открываем через схему
                                    await launchUrl(whatsappUrl,
                                        mode: LaunchMode.externalApplication);
                                    return NavigationActionPolicy.CANCEL;
                                  } else {
                                    log('❌ WhatsApp не установлен, открываем сайт');
                                    final fallbackUrl = Uri.parse(
                                        'https://api.whatsapp.com/send?text=${uri.queryParameters['text']}');
                                    if (await canLaunchUrl(fallbackUrl)) {
                                      // Если WhatsApp не установлен, открываем через сайт
                                      await launchUrl(fallbackUrl,
                                          mode: LaunchMode.externalApplication);
                                      return NavigationActionPolicy.CANCEL;
                                    }
                                  }
                                } catch (e) {
                                  log('Ошибка при открытии WhatsApp: $e');
                                }
                                return NavigationActionPolicy.CANCEL;
                              }
                              if (uri.scheme == 'tg' ||
                                  uri.host == 'telegram.me' ||
                                  uri.host == 't.me') {
                                try {
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode
                                            .externalNonBrowserApplication);
                                    return NavigationActionPolicy.CANCEL;
                                  } else {
                                    log('❌ Не удалось открыть Telegram-ссылку, пробуем через браузер');
                                    final fallbackUrl =
                                        Uri.parse('https://t.me/${uri.path}');
                                    if (await canLaunchUrl(fallbackUrl)) {
                                      await launchUrl(fallbackUrl,
                                          mode: LaunchMode
                                              .externalNonBrowserApplication);
                                      return NavigationActionPolicy.CANCEL;
                                    }
                                  }
                                } catch (e) {
                                  log('Ошибка при открытии Telegram: $e');
                                }
                                return NavigationActionPolicy.CANCEL;
                              }

                              if (externalSchemes.contains(uri.scheme) ||
                                  externalDomains.any(
                                      (domain) => uri.host.contains(domain))) {
                                try {
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                    return NavigationActionPolicy.CANCEL;
                                  }
                                } catch (e) {
                                  log('Ошибка при открытии ссылки: $e');
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
