// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Innovate`
  String get welcomeTitle1 {
    return Intl.message('Innovate', name: 'welcomeTitle1', desc: '', args: []);
  }

  /// `Boost`
  String get welcomeTitle2 {
    return Intl.message('Boost', name: 'welcomeTitle2', desc: '', args: []);
  }

  /// `Scale`
  String get welcomeTitle3 {
    return Intl.message('Scale', name: 'welcomeTitle3', desc: '', args: []);
  }

  /// `#Automate today# and grow your business.`
  String get welcomeMessage3 {
    return Intl.message(
      '#Automate today# and grow your business.',
      name: 'welcomeMessage3',
      desc: '',
      args: [],
    );
  }

  /// `Optimize your time and multiply your #sales.#`
  String get welcomeMessage2 {
    return Intl.message(
      'Optimize your time and multiply your #sales.#',
      name: 'welcomeMessage2',
      desc: '',
      args: [],
    );
  }

  /// `Experience #innovation# in business.`
  String get welcomeMessage1 {
    return Intl.message(
      'Experience #innovation# in business.',
      name: 'welcomeMessage1',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get thisFieldIsRequired {
    return Intl.message(
      'This field is required',
      name: 'thisFieldIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get invalidEmail {
    return Intl.message(
      'Invalid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least:`
  String get passwordMustContainAtLeast {
    return Intl.message(
      'Password must contain at least:',
      name: 'passwordMustContainAtLeast',
      desc: '',
      args: [],
    );
  }

  /// `6 characters`
  String get passMinCharacters {
    return Intl.message(
      '6 characters',
      name: 'passMinCharacters',
      desc: '',
      args: [],
    );
  }

  /// `One letter`
  String get passOneLetter {
    return Intl.message(
      'One letter',
      name: 'passOneLetter',
      desc: '',
      args: [],
    );
  }

  /// `One number`
  String get passOneNumber {
    return Intl.message(
      'One number',
      name: 'passOneNumber',
      desc: '',
      args: [],
    );
  }

  /// `You have to enter a valid email.`
  String get youHaveToEnterAValidEmail {
    return Intl.message(
      'You have to enter a valid email.',
      name: 'youHaveToEnterAValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 3 characters long`
  String get nameMustBeAtLeast3CharactersLong {
    return Intl.message(
      'Name must be at least 3 characters long',
      name: 'nameMustBeAtLeast3CharactersLong',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password. Please try again.`
  String get invalidEmailOrPasswordPleaseTryAgain {
    return Intl.message(
      'Invalid email or password. Please try again.',
      name: 'invalidEmailOrPasswordPleaseTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Email & Password`
  String get emailPassword {
    return Intl.message(
      'Email & Password',
      name: 'emailPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Sorry about this`
  String get sorryAboutThis {
    return Intl.message(
      'Sorry about this',
      name: 'sorryAboutThis',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Your Password?`
  String get forgotYourPassword {
    return Intl.message(
      'Forgot Your Password?',
      name: 'forgotYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `We will send you an email with a code to reset your password.`
  String get weWillSendYouAnEmailWithACodeTo {
    return Intl.message(
      'We will send you an email with a code to reset your password.',
      name: 'weWillSendYouAnEmailWithACodeTo',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong while sending the otp code, please try again later.`
  String get somethingWentWrongWhileSendingTheOtpCodePleaseTry {
    return Intl.message(
      'Something went wrong while sending the otp code, please try again later.',
      name: 'somethingWentWrongWhileSendingTheOtpCodePleaseTry',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resendCode {
    return Intl.message('Resend Code', name: 'resendCode', desc: '', args: []);
  }

  /// `Verify Code`
  String get verifyCode {
    return Intl.message('Verify Code', name: 'verifyCode', desc: '', args: []);
  }

  /// `A 6-digit code has been sent to the email you provided. This code will expire in 5 minutes.`
  String get verifyCodeMessage {
    return Intl.message(
      'A 6-digit code has been sent to the email you provided. This code will expire in 5 minutes.',
      name: 'verifyCodeMessage',
      desc: '',
      args: [],
    );
  }

  /// `OTP Code`
  String get otpCode {
    return Intl.message('OTP Code', name: 'otpCode', desc: '', args: []);
  }

  /// `Password Restored`
  String get passwordRestored {
    return Intl.message(
      'Password Restored',
      name: 'passwordRestored',
      desc: '',
      args: [],
    );
  }

  /// `Your password has been restored successfully.`
  String get passwordRestoredSuccessfully {
    return Intl.message(
      'Your password has been restored successfully.',
      name: 'passwordRestoredSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Verification Failed`
  String get verificationFailed {
    return Intl.message(
      'Verification Failed',
      name: 'verificationFailed',
      desc: '',
      args: [],
    );
  }

  /// `The verification process failed. Please try again.`
  String get verificationFailedMessage {
    return Intl.message(
      'The verification process failed. Please try again.',
      name: 'verificationFailedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Sign In Now`
  String get signInNow {
    return Intl.message('Sign In Now', name: 'signInNow', desc: '', args: []);
  }

  /// `I agree to change my password!`
  String get iAgreeToChangeMyPassword {
    return Intl.message(
      'I agree to change my password!',
      name: 'iAgreeToChangeMyPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Your Password is`
  String get yourPasswordIs {
    return Intl.message(
      'Your Password is',
      name: 'yourPasswordIs',
      desc: '',
      args: [],
    );
  }

  /// `NEVER STORED`
  String get neverStored {
    return Intl.message(
      'NEVER STORED',
      name: 'neverStored',
      desc: '',
      args: [],
    );
  }

  /// `in the app.`
  String get inTheApp {
    return Intl.message('in the app.', name: 'inTheApp', desc: '', args: []);
  }

  /// `Try again`
  String get tryAgain {
    return Intl.message('Try again', name: 'tryAgain', desc: '', args: []);
  }

  /// `Sign In`
  String get signIn {
    return Intl.message('Sign In', name: 'signIn', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Your email or password doesn’t seem to match. Please check your details and try again.`
  String get loginErrorMessage {
    return Intl.message(
      'Your email or password doesn’t seem to match. Please check your details and try again.',
      name: 'loginErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `Continue`
  String get continueText {
    return Intl.message('Continue', name: 'continueText', desc: '', args: []);
  }

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Update available`
  String get updateAvailable {
    return Intl.message(
      'Update available',
      name: 'updateAvailable',
      desc: '',
      args: [],
    );
  }

  /// `There is a new version of the app available. Please update to continue using all features.`
  String get updateAvailableMessage {
    return Intl.message(
      'There is a new version of the app available. Please update to continue using all features.',
      name: 'updateAvailableMessage',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `What’s Your Name?`
  String get whatsYourName {
    return Intl.message(
      'What’s Your Name?',
      name: 'whatsYourName',
      desc: '',
      args: [],
    );
  }

  /// `Privacy & Terms`
  String get privacyTerms {
    return Intl.message(
      'Privacy & Terms',
      name: 'privacyTerms',
      desc: '',
      args: [],
    );
  }

  /// `By continuing, you agree to our`
  String get privacyText1 {
    return Intl.message(
      'By continuing, you agree to our',
      name: 'privacyText1',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get and {
    return Intl.message('and', name: 'and', desc: '', args: []);
  }

  /// `Terms of Use.`
  String get termsOfUse {
    return Intl.message(
      'Terms of Use.',
      name: 'termsOfUse',
      desc: '',
      args: [],
    );
  }

  /// `Your information will be kept safe and secure.`
  String get informationSafeMessage {
    return Intl.message(
      'Your information will be kept safe and secure.',
      name: 'informationSafeMessage',
      desc: '',
      args: [],
    );
  }

  /// `We couldn’t complete your registration this time. Please try again, and if the issue continues, come back a little later.`
  String get registrationErrorMessage {
    return Intl.message(
      'We couldn’t complete your registration this time. Please try again, and if the issue continues, come back a little later.',
      name: 'registrationErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `I Have An Account`
  String get iHaveAnAccount {
    return Intl.message(
      'I Have An Account',
      name: 'iHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create an Account`
  String get createAnAccount {
    return Intl.message(
      'Create an Account',
      name: 'createAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Nombre`
  String get firstName {
    return Intl.message('Nombre', name: 'firstName', desc: '', args: []);
  }

  /// `Apellido`
  String get lastName {
    return Intl.message('Apellido', name: 'lastName', desc: '', args: []);
  }

  /// `El nombre debe tener al menos 3 caracteres`
  String get lastNameMustBeAtLeast3CharactersLong {
    return Intl.message(
      'El nombre debe tener al menos 3 caracteres',
      name: 'lastNameMustBeAtLeast3CharactersLong',
      desc: '',
      args: [],
    );
  }

  /// `Teléfono`
  String get phone {
    return Intl.message('Teléfono', name: 'phone', desc: '', args: []);
  }

  /// `¿Cuál es tu número de teléfono?`
  String get whatsYourPhoneNumber {
    return Intl.message(
      '¿Cuál es tu número de teléfono?',
      name: 'whatsYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa un número de teléfono válido`
  String get enterAValidPhoneNumber {
    return Intl.message(
      'Ingresa un número de teléfono válido',
      name: 'enterAValidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `El teléfono solo puede contener dígitos`
  String get phoneNumberDigitsError {
    return Intl.message(
      'El teléfono solo puede contener dígitos',
      name: 'phoneNumberDigitsError',
      desc: '',
      args: [],
    );
  }

  /// `El teléfono debe tener entre 10 y 15 dígitos`
  String get phoneNumberLengthError {
    return Intl.message(
      'El teléfono debe tener entre 10 y 15 dígitos',
      name: 'phoneNumberLengthError',
      desc: '',
      args: [],
    );
  }

  /// `Confirmar Contraseña`
  String get confirmPassword {
    return Intl.message(
      'Confirmar Contraseña',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `La contraseña no coincide`
  String get passwordDontMatch {
    return Intl.message(
      'La contraseña no coincide',
      name: 'passwordDontMatch',
      desc: '',
      args: [],
    );
  }

  /// `Lo usaremos para dirigirnos a ti.`
  String get signUpNameMessage {
    return Intl.message(
      'Lo usaremos para dirigirnos a ti.',
      name: 'signUpNameMessage',
      desc: '',
      args: [],
    );
  }

  /// `esta será una forma rápida para contactarte.`
  String get signUpPhoneMessage {
    return Intl.message(
      'esta será una forma rápida para contactarte.',
      name: 'signUpPhoneMessage',
      desc: '',
      args: [],
    );
  }

  /// `Casi terminas, solo agrega tus credenciales para iniciar sesion.`
  String get signUpEmailMessage {
    return Intl.message(
      'Casi terminas, solo agrega tus credenciales para iniciar sesion.',
      name: 'signUpEmailMessage',
      desc: '',
      args: [],
    );
  }

  /// `o`
  String get or {
    return Intl.message('o', name: 'or', desc: '', args: []);
  }

  /// `O inicia session con`
  String get orLoginWith {
    return Intl.message(
      'O inicia session con',
      name: 'orLoginWith',
      desc: '',
      args: [],
    );
  }

  /// `Hola, bienvenido de nuevo!`
  String get loginGreetingMessage {
    return Intl.message(
      'Hola, bienvenido de nuevo!',
      name: 'loginGreetingMessage',
      desc: '',
      args: [],
    );
  }

  /// `1 letra mayúscula`
  String get passOneUppercaseLetter {
    return Intl.message(
      '1 letra mayúscula',
      name: 'passOneUppercaseLetter',
      desc: '',
      args: [],
    );
  }

  /// `Campañas`
  String get campains {
    return Intl.message('Campañas', name: 'campains', desc: '', args: []);
  }

  /// `Bienvenido`
  String get welcome {
    return Intl.message('Bienvenido', name: 'welcome', desc: '', args: []);
  }

  /// `Suscripción actual`
  String get suscripcionActual {
    return Intl.message(
      'Suscripción actual',
      name: 'suscripcionActual',
      desc: '',
      args: [],
    );
  }

  /// `Plan`
  String get plan {
    return Intl.message('Plan', name: 'plan', desc: '', args: []);
  }

  /// `Fecha Inicio`
  String get fechaInicio {
    return Intl.message(
      'Fecha Inicio',
      name: 'fechaInicio',
      desc: '',
      args: [],
    );
  }

  /// `Próximo cobro`
  String get proximoCobro {
    return Intl.message(
      'Próximo cobro',
      name: 'proximoCobro',
      desc: '',
      args: [],
    );
  }

  /// `Método de pago`
  String get metodoDePago {
    return Intl.message(
      'Método de pago',
      name: 'metodoDePago',
      desc: '',
      args: [],
    );
  }

  /// `Estado`
  String get status {
    return Intl.message('Estado', name: 'status', desc: '', args: []);
  }

  /// `Usos y estadísticas`
  String get usosYEstadisticas {
    return Intl.message(
      'Usos y estadísticas',
      name: 'usosYEstadisticas',
      desc: '',
      args: [],
    );
  }

  /// `Uso de Almacenamiento`
  String get storageUsage {
    return Intl.message(
      'Uso de Almacenamiento',
      name: 'storageUsage',
      desc: '',
      args: [],
    );
  }

  /// `Storage`
  String get storage {
    return Intl.message('Storage', name: 'storage', desc: '', args: []);
  }

  /// `Archivos`
  String get files {
    return Intl.message('Archivos', name: 'files', desc: '', args: []);
  }

  /// `Cancelado`
  String get cancelled {
    return Intl.message('Cancelado', name: 'cancelled', desc: '', args: []);
  }

  /// `Pendiente`
  String get pending {
    return Intl.message('Pendiente', name: 'pending', desc: '', args: []);
  }

  /// `Enviado`
  String get sent {
    return Intl.message('Enviado', name: 'sent', desc: '', args: []);
  }

  /// `Campañas`
  String get campainsUsage {
    return Intl.message('Campañas', name: 'campainsUsage', desc: '', args: []);
  }

  /// `Subscription`
  String get subscriptionUsage {
    return Intl.message(
      'Subscription',
      name: 'subscriptionUsage',
      desc: '',
      args: [],
    );
  }

  /// `Activa`
  String get activa {
    return Intl.message('Activa', name: 'activa', desc: '', args: []);
  }

  /// `Cancelada`
  String get cancelada {
    return Intl.message('Cancelada', name: 'cancelada', desc: '', args: []);
  }

  /// `Expirada`
  String get expirada {
    return Intl.message('Expirada', name: 'expirada', desc: '', args: []);
  }

  /// `Vencida`
  String get vencida {
    return Intl.message('Vencida', name: 'vencida', desc: '', args: []);
  }

  /// `Revisión`
  String get revision {
    return Intl.message('Revisión', name: 'revision', desc: '', args: []);
  }

  /// `Paypal`
  String get paypal {
    return Intl.message('Paypal', name: 'paypal', desc: '', args: []);
  }

  /// `Stripe`
  String get stripe {
    return Intl.message('Stripe', name: 'stripe', desc: '', args: []);
  }

  /// `Manualmente`
  String get manually {
    return Intl.message('Manualmente', name: 'manually', desc: '', args: []);
  }

  /// `Ver Historial`
  String get verHistorial {
    return Intl.message(
      'Ver Historial',
      name: 'verHistorial',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get search {
    return Intl.message('Search...', name: 'search', desc: '', args: []);
  }

  /// `Crear Campaña`
  String get createCampaign {
    return Intl.message(
      'Crear Campaña',
      name: 'createCampaign',
      desc: '',
      args: [],
    );
  }

  /// `Historial`
  String get history {
    return Intl.message('Historial', name: 'history', desc: '', args: []);
  }

  /// `Mensaje`
  String get message {
    return Intl.message('Mensaje', name: 'message', desc: '', args: []);
  }

  /// `Destinatario`
  String get recipient {
    return Intl.message('Destinatario', name: 'recipient', desc: '', args: []);
  }

  /// `Contact`
  String get contact {
    return Intl.message('Contact', name: 'contact', desc: '', args: []);
  }

  /// `Fecha`
  String get date {
    return Intl.message('Fecha', name: 'date', desc: '', args: []);
  }

  /// `Aún no hay campañas disponibles.`
  String get noCampaignsYet {
    return Intl.message(
      'Aún no hay campañas disponibles.',
      name: 'noCampaignsYet',
      desc: '',
      args: [],
    );
  }

  /// `SMS`
  String get sms {
    return Intl.message('SMS', name: 'sms', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
