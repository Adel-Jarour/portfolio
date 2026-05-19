import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/data/models/portfolio_info_model.dart';
import 'package:portfolio/data/repositories/portfolio_repository.dart';
import 'package:portfolio/localization/strings.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:emailjs/emailjs.dart' as emailjs;

class ContactAnimController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController animCtrl;
  bool _animated = false;

  final portfolioInfo = Rxn<PortfolioInfoModel>();
  final _repo = PortfolioRepository.instance;
  StreamSubscription<PortfolioInfoModel>? _infoSub;

  // Form Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _subscribeInfo();
  }

  void _subscribeInfo() {
    _infoSub = _repo.watchPortfolioInfo().listen((info) {
      portfolioInfo.value = info;
    });
  }

  void sendEmail() async {
    if (isSending.value) return;

    if (formKey.currentState?.validate() ?? false) {
      isSending.value = true;

      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final subject = subjectController.text.trim();
      final message = messageController.text.trim();

      try {
        // Get these 3 values from your EmailJS dashboard
        const String serviceId = 'service_zcskp6k';
        const String templateId = 'template_28hwf3k';
        const String publicKey = 'qmDEZcoKLZf-5uNWQ';
        const String privateKey = '3jGjgFte83r0pYAz7ScNA';

        // Map your form fields to the template variables
        final templateParams = {
          'user_name': name, // Must match variable names in your EmailJS template
          'user_email': email,
          'user_subject': subject,
          'user_message': message,
          'to_email': 'your.email@gmail.com', // Where you want to receive it
        };

        await emailjs.send(
          serviceId,
          templateId,
          templateParams,
          emailjs.Options(
            publicKey: publicKey,
            privateKey: privateKey,
          ),
        );

        // Clear fields on success
        nameController.clear();
        emailController.clear();
        subjectController.clear();
        messageController.clear();

        // Show success message to user
        print('Email sent successfully!');
        Get.snackbar(
          'Success',
          Strings.emailSendSuccess.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      } catch (error) {
        print('Failed to send email: $error');
        Get.snackbar(
          'Error',
          '${Strings.emailSendFailure.tr} ($error)',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      } finally {
        isSending.value = false;
      }
    }
  }

  void onVisibility(VisibilityInfo info) {
    if (!_animated && info.visibleFraction > 0.1) {
      _animated = true;
      animCtrl.forward();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    _infoSub?.cancel();
    animCtrl.dispose();
    super.onClose();
  }
}
