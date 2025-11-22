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

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
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

  /// `Welcome to your new space of faith`
  String get welcomeTitle {
    return Intl.message(
      'Welcome to your new space of faith',
      name: 'welcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `A place to connect with yourself and with God every day.`
  String get welcomeSubtitle {
    return Intl.message(
      'A place to connect with yourself and with God every day.',
      name: 'welcomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Let’s Build Your Profile`
  String get profilePageTitle {
    return Intl.message(
      'Let’s Build Your Profile',
      name: 'profilePageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tell us a little about yourself.`
  String get profilePageSubtitle {
    return Intl.message(
      'Tell us a little about yourself.',
      name: 'profilePageSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message('Age', name: 'age', desc: '', args: []);
  }

  /// `💭 What would you like to find in this experience?`
  String get experiencePageTitle {
    return Intl.message(
      '💭 What would you like to find in this experience?',
      name: 'experiencePageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Select your Language`
  String get selectYourLanguage {
    return Intl.message(
      'Select your Language',
      name: 'selectYourLanguage',
      desc: '',
      args: [],
    );
  }

  /// `🕊️ Find inner peace `
  String get experienceQ1 {
    return Intl.message(
      '🕊️ Find inner peace ',
      name: 'experienceQ1',
      desc: '',
      args: [],
    );
  }

  /// `💭 Learn to manage my emotions`
  String get experienceQ2 {
    return Intl.message(
      '💭 Learn to manage my emotions',
      name: 'experienceQ2',
      desc: '',
      args: [],
    );
  }

  /// `🙏 Strengthen my faith`
  String get experienceQ3 {
    return Intl.message(
      '🙏 Strengthen my faith',
      name: 'experienceQ3',
      desc: '',
      args: [],
    );
  }

  /// `✨ Have a moment with God every day`
  String get experienceQ4 {
    return Intl.message(
      '✨ Have a moment with God every day',
      name: 'experienceQ4',
      desc: '',
      args: [],
    );
  }

  /// `🔥 Extremely committed`
  String get committedQ1 {
    return Intl.message(
      '🔥 Extremely committed',
      name: 'committedQ1',
      desc: '',
      args: [],
    );
  }

  /// `💪 Very committed`
  String get committedQ2 {
    return Intl.message(
      '💪 Very committed',
      name: 'committedQ2',
      desc: '',
      args: [],
    );
  }

  /// `🌿 Somewhat committed`
  String get committedQ3 {
    return Intl.message(
      '🌿 Somewhat committed',
      name: 'committedQ3',
      desc: '',
      args: [],
    );
  }

  /// `🌧️ A little`
  String get committedQ4 {
    return Intl.message(
      '🌧️ A little',
      name: 'committedQ4',
      desc: '',
      args: [],
    );
  }

  /// `👀 Just exploring`
  String get committedQ5 {
    return Intl.message(
      '👀 Just exploring',
      name: 'committedQ5',
      desc: '',
      args: [],
    );
  }

  /// `🙌 How committed are you with your faith?`
  String get committedPageTitle {
    return Intl.message(
      '🙌 How committed are you with your faith?',
      name: 'committedPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Age is required!`
  String get ageIsRequired {
    return Intl.message(
      'Age is required!',
      name: 'ageIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `🌿 Have you ever used a faith journal app before?`
  String get everUsedBeforeTitle {
    return Intl.message(
      '🌿 Have you ever used a faith journal app before?',
      name: 'everUsedBeforeTitle',
      desc: '',
      args: [],
    );
  }

  /// `🙏 Yes, I have used one before`
  String get everUsedBeforeQ1 {
    return Intl.message(
      '🙏 Yes, I have used one before',
      name: 'everUsedBeforeQ1',
      desc: '',
      args: [],
    );
  }

  /// `✨ No, this is my first time`
  String get everUsedBeforeQ2 {
    return Intl.message(
      '✨ No, this is my first time',
      name: 'everUsedBeforeQ2',
      desc: '',
      args: [],
    );
  }

  /// `🕊️ I’ve tried something similar`
  String get everUsedBeforeQ3 {
    return Intl.message(
      '🕊️ I’ve tried something similar',
      name: 'everUsedBeforeQ3',
      desc: '',
      args: [],
    );
  }

  /// `🌱 Join others growing stronger in faith`
  String get joinOthersTitle {
    return Intl.message(
      '🌱 Join others growing stronger in faith',
      name: 'joinOthersTitle',
      desc: '',
      args: [],
    );
  }

  /// `Grow in Faith`
  String get growInFaith {
    return Intl.message(
      'Grow in Faith',
      name: 'growInFaith',
      desc: '',
      args: [],
    );
  }

  /// `3 Days`
  String get days3 {
    return Intl.message('3 Days', name: 'days3', desc: '', args: []);
  }

  /// `15 Days`
  String get days15 {
    return Intl.message('15 Days', name: 'days15', desc: '', args: []);
  }

  /// `30 Days`
  String get days30 {
    return Intl.message('30 Days', name: 'days30', desc: '', args: []);
  }

  /// `+80% of those who use FaithMood feel their faith grow within 30 days.`
  String get joinOthersSubtitle {
    return Intl.message(
      '+80% of those who use FaithMood feel their faith grow within 30 days.',
      name: 'joinOthersSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `📖 Have you ever followed a guided plan to strengthen your faith?`
  String get guidedPlanTitle {
    return Intl.message(
      '📖 Have you ever followed a guided plan to strengthen your faith?',
      name: 'guidedPlanTitle',
      desc: '',
      args: [],
    );
  }

  /// `🙏 Yes, several times`
  String get guidedPlanQ1 {
    return Intl.message(
      '🙏 Yes, several times',
      name: 'guidedPlanQ1',
      desc: '',
      args: [],
    );
  }

  /// `📘 Once or twice`
  String get guidedPlanQ2 {
    return Intl.message(
      '📘 Once or twice',
      name: 'guidedPlanQ2',
      desc: '',
      args: [],
    );
  }

  /// `🌱 No, it’ll be my first time`
  String get guidedPlanQ3 {
    return Intl.message(
      '🌱 No, it’ll be my first time',
      name: 'guidedPlanQ3',
      desc: '',
      args: [],
    );
  }

  /// `🔔 Stay connected with your purpose`
  String get askNotificationTitle {
    return Intl.message(
      '🔔 Stay connected with your purpose',
      name: 'askNotificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `We’ll remind you of your daily reflection, prayers, and guided plans — only when it truly matters.`
  String get askNotificationSubtitle {
    return Intl.message(
      'We’ll remind you of your daily reflection, prayers, and guided plans — only when it truly matters.',
      name: 'askNotificationSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Maybe later`
  String get maybeLater {
    return Intl.message('Maybe later', name: 'maybeLater', desc: '', args: []);
  }

  /// `Allow Notifications`
  String get allowNotifications {
    return Intl.message(
      'Allow Notifications',
      name: 'allowNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Leave Rating`
  String get leaveRating {
    return Intl.message(
      'Leave Rating',
      name: 'leaveRating',
      desc: '',
      args: [],
    );
  }

  /// `Start For Free`
  String get startFreeTrial {
    return Intl.message(
      'Start For Free',
      name: 'startFreeTrial',
      desc: '',
      args: [],
    );
  }

  /// `🙏 We’re preparing your space...`
  String get preparingPageTitle {
    return Intl.message(
      '🙏 We’re preparing your space...',
      name: 'preparingPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `The Lord gives you strength when you need it most.`
  String get preparingPageSubtitle {
    return Intl.message(
      'The Lord gives you strength when you need it most.',
      name: 'preparingPageSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Personalizing your profile...`
  String get preparingPageT1 {
    return Intl.message(
      'Personalizing your profile...',
      name: 'preparingPageT1',
      desc: '',
      args: [],
    );
  }

  /// `Setting up your emotions journey...`
  String get preparingPageT2 {
    return Intl.message(
      'Setting up your emotions journey...',
      name: 'preparingPageT2',
      desc: '',
      args: [],
    );
  }

  /// `Final touches for your experience...`
  String get preparingPageT3 {
    return Intl.message(
      'Final touches for your experience...',
      name: 'preparingPageT3',
      desc: '',
      args: [],
    );
  }

  /// `✔️ No payment required now`
  String get noPaymentRequiredNow {
    return Intl.message(
      '✔️ No payment required now',
      name: 'noPaymentRequiredNow',
      desc: '',
      args: [],
    );
  }

  /// `Just ### per month - Cancel anytime`
  String get just449PerMonthCancelAnytime {
    return Intl.message(
      'Just ### per month - Cancel anytime',
      name: 'just449PerMonthCancelAnytime',
      desc: '',
      args: [],
    );
  }

  /// `✨ Your journey is just beginning`
  String get paywallTitle {
    return Intl.message(
      '✨ Your journey is just beginning',
      name: 'paywallTitle',
      desc: '',
      args: [],
    );
  }

  /// `Discover a calm, ad-free space made to nurture your faith through reflection and growth.`
  String get paywallSubtitle {
    return Intl.message(
      'Discover a calm, ad-free space made to nurture your faith through reflection and growth.',
      name: 'paywallSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `A friend’s recommendation`
  String get socialDiscoverQ9 {
    return Intl.message(
      'A friend’s recommendation',
      name: 'socialDiscoverQ9',
      desc: '',
      args: [],
    );
  }

  /// `Church / community`
  String get socialDiscoverQ10 {
    return Intl.message(
      'Church / community',
      name: 'socialDiscoverQ10',
      desc: '',
      args: [],
    );
  }

  /// `Searching for Christian apps`
  String get socialDiscoverQ11 {
    return Intl.message(
      'Searching for Christian apps',
      name: 'socialDiscoverQ11',
      desc: '',
      args: [],
    );
  }

  /// `⭐ How did you hear about the app?`
  String get socialDiscoverTitle {
    return Intl.message(
      '⭐ How did you hear about the app?',
      name: 'socialDiscoverTitle',
      desc: '',
      args: [],
    );
  }

  /// `The Lord is my shepherd; I shall not want.`
  String get psaml231Verse {
    return Intl.message(
      'The Lord is my shepherd; I shall not want.',
      name: 'psaml231Verse',
      desc: '',
      args: [],
    );
  }

  /// `Psalm 23:1`
  String get psalm231 {
    return Intl.message('Psalm 23:1', name: 'psalm231', desc: '', args: []);
  }

  /// `📖 Guided Faith Plans`
  String get guidedFaithPlans {
    return Intl.message(
      '📖 Guided Faith Plans',
      name: 'guidedFaithPlans',
      desc: '',
      args: [],
    );
  }

  /// `💭 Unlimited Mood Track`
  String get unlimitedMoodTrack {
    return Intl.message(
      '💭 Unlimited Mood Track',
      name: 'unlimitedMoodTrack',
      desc: '',
      args: [],
    );
  }

  /// `✨ Advance Progress Tracker`
  String get advanceProgressTracker {
    return Intl.message(
      '✨ Advance Progress Tracker',
      name: 'advanceProgressTracker',
      desc: '',
      args: [],
    );
  }

  /// `🚫 Ad-Free Experience`
  String get adfreeExperience {
    return Intl.message(
      '🚫 Ad-Free Experience',
      name: 'adfreeExperience',
      desc: '',
      args: [],
    );
  }

  /// `🎉 Enjoying your experience so far?`
  String get ratingContentTitle {
    return Intl.message(
      '🎉 Enjoying your experience so far?',
      name: 'ratingContentTitle',
      desc: '',
      args: [],
    );
  }

  /// `Share your thoughts — your feedback inspires others 🙏`
  String get ratingContentSubtitle {
    return Intl.message(
      'Share your thoughts — your feedback inspires others 🙏',
      name: 'ratingContentSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `FaithMood was made for people like you`
  String get ratingContentDesc {
    return Intl.message(
      'FaithMood was made for people like you',
      name: 'ratingContentDesc',
      desc: '',
      args: [],
    );
  }

  /// `It’s my favorite moment of the day — just me and God.`
  String get ratingContentP4Rating {
    return Intl.message(
      'It’s my favorite moment of the day — just me and God.',
      name: 'ratingContentP4Rating',
      desc: '',
      args: [],
    );
  }

  /// `Select an Option`
  String get selectAnOption {
    return Intl.message(
      'Select an Option',
      name: 'selectAnOption',
      desc: '',
      args: [],
    );
  }

  /// `Devotionals`
  String get devotionals {
    return Intl.message('Devotionals', name: 'devotionals', desc: '', args: []);
  }

  /// `Find a plan that fits your journey.`
  String get findAPlanThatFitsYourJourney {
    return Intl.message(
      'Find a plan that fits your journey.',
      name: 'findAPlanThatFitsYourJourney',
      desc: '',
      args: [],
    );
  }

  /// `View More`
  String get viewMore {
    return Intl.message('View More', name: 'viewMore', desc: '', args: []);
  }

  /// `Select Tag`
  String get selectTag {
    return Intl.message('Select Tag', name: 'selectTag', desc: '', args: []);
  }

  /// `Unable to load categories`
  String get unableToLoadCategories {
    return Intl.message(
      'Unable to load categories',
      name: 'unableToLoadCategories',
      desc: '',
      args: [],
    );
  }

  /// `No categories available`
  String get noCategoriesAvailable {
    return Intl.message(
      'No categories available',
      name: 'noCategoriesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Unlock Now`
  String get unlockNow {
    return Intl.message('Unlock Now', name: 'unlockNow', desc: '', args: []);
  }

  /// `Reflect Now`
  String get reflectNow {
    return Intl.message('Reflect Now', name: 'reflectNow', desc: '', args: []);
  }

  /// `Explore`
  String get explore {
    return Intl.message('Explore', name: 'explore', desc: '', args: []);
  }

  /// `Your Week in Emotions`
  String get yourWeekInEmotions {
    return Intl.message(
      'Your Week in Emotions',
      name: 'yourWeekInEmotions',
      desc: '',
      args: [],
    );
  }

  /// `Verse of the day`
  String get verseOfTheDay {
    return Intl.message(
      'Verse of the day',
      name: 'verseOfTheDay',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load verse. Please try again later.`
  String get unableToLoadVersePleaseTryAgainLater {
    return Intl.message(
      'Unable to load verse. Please try again later.',
      name: 'unableToLoadVersePleaseTryAgainLater',
      desc: '',
      args: [],
    );
  }

  /// `Choose Your Next Step`
  String get chooseYourNextStep {
    return Intl.message(
      'Choose Your Next Step',
      name: 'chooseYourNextStep',
      desc: '',
      args: [],
    );
  }

  /// `Your Journal`
  String get yourJournal {
    return Intl.message(
      'Your Journal',
      name: 'yourJournal',
      desc: '',
      args: [],
    );
  }

  /// `Capture your thoughts each day.`
  String get captureYourThoughtsEachDay {
    return Intl.message(
      'Capture your thoughts each day.',
      name: 'captureYourThoughtsEachDay',
      desc: '',
      args: [],
    );
  }

  /// `FFollow guided daily devotionals`
  String get ffollowGuidedDailyDevotionals {
    return Intl.message(
      'FFollow guided daily devotionals',
      name: 'ffollowGuidedDailyDevotionals',
      desc: '',
      args: [],
    );
  }

  /// `Grow with Guidance`
  String get growWithGuidance {
    return Intl.message(
      'Grow with Guidance',
      name: 'growWithGuidance',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load devotionals`
  String get unableToLoadDevotionals {
    return Intl.message(
      'Unable to load devotionals',
      name: 'unableToLoadDevotionals',
      desc: '',
      args: [],
    );
  }

  /// `No devotionals available`
  String get noDevotionalsAvailable {
    return Intl.message(
      'No devotionals available',
      name: 'noDevotionalsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Devotional`
  String get devotional {
    return Intl.message('Devotional', name: 'devotional', desc: '', args: []);
  }

  /// `Tags`
  String get tags {
    return Intl.message('Tags', name: 'tags', desc: '', args: []);
  }

  /// `Key Learnings`
  String get keyLearnings {
    return Intl.message(
      'Key Learnings',
      name: 'keyLearnings',
      desc: '',
      args: [],
    );
  }

  /// `Relevant Verses`
  String get relevantVerses {
    return Intl.message(
      'Relevant Verses',
      name: 'relevantVerses',
      desc: '',
      args: [],
    );
  }

  /// `My Reflection`
  String get myReflection {
    return Intl.message(
      'My Reflection',
      name: 'myReflection',
      desc: '',
      args: [],
    );
  }

  /// `What's on your heart today?`
  String get whatsOnYourHeartToday {
    return Intl.message(
      'What\'s on your heart today?',
      name: 'whatsOnYourHeartToday',
      desc: '',
      args: [],
    );
  }

  /// `Save Note`
  String get saveNotes {
    return Intl.message('Save Note', name: 'saveNotes', desc: '', args: []);
  }

  /// `Unsaved Note`
  String get unsavedNoteTitle {
    return Intl.message(
      'Unsaved Note',
      name: 'unsavedNoteTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have an unsaved note. Would you like to save it before leaving?`
  String get unsavedNoteMessage {
    return Intl.message(
      'You have an unsaved note. Would you like to save it before leaving?',
      name: 'unsavedNoteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Continue Without Note`
  String get continueWithoutNote {
    return Intl.message(
      'Continue Without Note',
      name: 'continueWithoutNote',
      desc: '',
      args: [],
    );
  }

  /// `Note saved successfully`
  String get noteSavedSuccessfully {
    return Intl.message(
      'Note saved successfully',
      name: 'noteSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error saving note`
  String get errorSavingNote {
    return Intl.message(
      'Error saving note',
      name: 'errorSavingNote',
      desc: '',
      args: [],
    );
  }

  /// `Where is your heart today?`
  String get whereIsYourHeartToday {
    return Intl.message(
      'Where is your heart today?',
      name: 'whereIsYourHeartToday',
      desc: '',
      args: [],
    );
  }

  /// `Choose the mood that best reflects your heart right now.`
  String get chooseMoodThatBestReflects {
    return Intl.message(
      'Choose the mood that best reflects your heart right now.',
      name: 'chooseMoodThatBestReflects',
      desc: '',
      args: [],
    );
  }

  /// `Select the state that resonates with your spiritual side.`
  String get selectStateThatResonates {
    return Intl.message(
      'Select the state that resonates with your spiritual side.',
      name: 'selectStateThatResonates',
      desc: '',
      args: [],
    );
  }

  /// `How would you describe your day?`
  String get howWouldYouDescribeYourDay {
    return Intl.message(
      'How would you describe your day?',
      name: 'howWouldYouDescribeYourDay',
      desc: '',
      args: [],
    );
  }

  /// `Write what's on your heart — how you felt, what you learned, or what you prayed for today.`
  String get writeWhatsOnYourHeart {
    return Intl.message(
      'Write what\'s on your heart — how you felt, what you learned, or what you prayed for today.',
      name: 'writeWhatsOnYourHeart',
      desc: '',
      args: [],
    );
  }

  /// `I'm grateful for...`
  String get imGratefulFor {
    return Intl.message(
      'I\'m grateful for...',
      name: 'imGratefulFor',
      desc: '',
      args: [],
    );
  }

  /// `Tip`
  String get tip {
    return Intl.message('Tip', name: 'tip', desc: '', args: []);
  }

  /// `You can revisit this note later in your Journal.`
  String get youCanRevisitThisNote {
    return Intl.message(
      'You can revisit this note later in your Journal.',
      name: 'youCanRevisitThisNote',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load moods`
  String get unableToLoadMoods {
    return Intl.message(
      'Unable to load moods',
      name: 'unableToLoadMoods',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Add to My Journal`
  String get addToMyJournal {
    return Intl.message(
      'Add to My Journal',
      name: 'addToMyJournal',
      desc: '',
      args: [],
    );
  }

  /// `Hey ###, how are you feeling today?`
  String get heyHowAreYouFeelingToday {
    return Intl.message(
      'Hey ###, how are you feeling today?',
      name: 'heyHowAreYouFeelingToday',
      desc: '',
      args: [],
    );
  }

  /// `Please select an emotional mood`
  String get pleaseSelectEmotionalMood {
    return Intl.message(
      'Please select an emotional mood',
      name: 'pleaseSelectEmotionalMood',
      desc: '',
      args: [],
    );
  }

  /// `Please select a spiritual mood`
  String get pleaseSelectSpiritualMood {
    return Intl.message(
      'Please select a spiritual mood',
      name: 'pleaseSelectSpiritualMood',
      desc: '',
      args: [],
    );
  }

  /// `(Optional)`
  String get optional {
    return Intl.message('(Optional)', name: 'optional', desc: '', args: []);
  }

  /// `Congratulations`
  String get moodAddedSuccessfully {
    return Intl.message(
      'Congratulations',
      name: 'moodAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully logged your first mood.`
  String get moodAddedSuccessfullyMessage {
    return Intl.message(
      'You have successfully logged your first mood.',
      name: 'moodAddedSuccessfullyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Error saving mood. Please try again.`
  String get errorSavingMood {
    return Intl.message(
      'Error saving mood. Please try again.',
      name: 'errorSavingMood',
      desc: '',
      args: [],
    );
  }

  /// `Go to Journal`
  String get goToJournal {
    return Intl.message(
      'Go to Journal',
      name: 'goToJournal',
      desc: '',
      args: [],
    );
  }

  /// `My Journal`
  String get myJournal {
    return Intl.message('My Journal', name: 'myJournal', desc: '', args: []);
  }

  /// `Search journals...`
  String get searchJournals {
    return Intl.message(
      'Search journals...',
      name: 'searchJournals',
      desc: '',
      args: [],
    );
  }

  /// `Moods`
  String get moods {
    return Intl.message('Moods', name: 'moods', desc: '', args: []);
  }

  /// `Sort by Date`
  String get sortByDate {
    return Intl.message('Sort by Date', name: 'sortByDate', desc: '', args: []);
  }

  /// `Filter by Mood`
  String get filterByMood {
    return Intl.message(
      'Filter by Mood',
      name: 'filterByMood',
      desc: '',
      args: [],
    );
  }

  /// `All Entries`
  String get allEntries {
    return Intl.message('All Entries', name: 'allEntries', desc: '', args: []);
  }

  /// `No journal entries`
  String get noJournalEntries {
    return Intl.message(
      'No journal entries',
      name: 'noJournalEntries',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load journal entries`
  String get unableToLoadJournalEntries {
    return Intl.message(
      'Unable to load journal entries',
      name: 'unableToLoadJournalEntries',
      desc: '',
      args: [],
    );
  }

  /// `Apply Filters`
  String get applyFilters {
    return Intl.message(
      'Apply Filters',
      name: 'applyFilters',
      desc: '',
      args: [],
    );
  }

  /// `Clear Filters`
  String get clearFilters {
    return Intl.message(
      'Clear Filters',
      name: 'clearFilters',
      desc: '',
      args: [],
    );
  }

  /// `Sort By`
  String get sortBy {
    return Intl.message('Sort By', name: 'sortBy', desc: '', args: []);
  }

  /// `Order`
  String get order {
    return Intl.message('Order', name: 'order', desc: '', args: []);
  }

  /// `Ascending`
  String get ascending {
    return Intl.message('Ascending', name: 'ascending', desc: '', args: []);
  }

  /// `Descending`
  String get descending {
    return Intl.message('Descending', name: 'descending', desc: '', args: []);
  }

  /// `Start Date`
  String get startDate {
    return Intl.message('Start Date', name: 'startDate', desc: '', args: []);
  }

  /// `End Date`
  String get endDate {
    return Intl.message('End Date', name: 'endDate', desc: '', args: []);
  }

  /// `Emotional Mood`
  String get emotionalMood {
    return Intl.message(
      'Emotional Mood',
      name: 'emotionalMood',
      desc: '',
      args: [],
    );
  }

  /// `Spiritual Mood`
  String get spiritualMood {
    return Intl.message(
      'Spiritual Mood',
      name: 'spiritualMood',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `With Note`
  String get withNote {
    return Intl.message('With Note', name: 'withNote', desc: '', args: []);
  }

  /// `Without Note`
  String get withoutNote {
    return Intl.message(
      'Without Note',
      name: 'withoutNote',
      desc: '',
      args: [],
    );
  }

  /// `More Filters`
  String get moreFilters {
    return Intl.message(
      'More Filters',
      name: 'moreFilters',
      desc: '',
      args: [],
    );
  }

  /// `Emotions`
  String get emotions {
    return Intl.message('Emotions', name: 'emotions', desc: '', args: []);
  }

  /// `Date Range`
  String get dateRange {
    return Intl.message('Date Range', name: 'dateRange', desc: '', args: []);
  }

  /// `No emotional moods available`
  String get noEmotionalMoodsAvailable {
    return Intl.message(
      'No emotional moods available',
      name: 'noEmotionalMoodsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No spiritual moods available`
  String get noSpiritualMoodsAvailable {
    return Intl.message(
      'No spiritual moods available',
      name: 'noSpiritualMoodsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get noSearchResults {
    return Intl.message(
      'No results found',
      name: 'noSearchResults',
      desc: '',
      args: [],
    );
  }

  /// `With Notes`
  String get withNotes {
    return Intl.message('With Notes', name: 'withNotes', desc: '', args: []);
  }

  /// `Journal Entry`
  String get journalEntry {
    return Intl.message(
      'Journal Entry',
      name: 'journalEntry',
      desc: '',
      args: [],
    );
  }

  /// `Feeling`
  String get feeling {
    return Intl.message('Feeling', name: 'feeling', desc: '', args: []);
  }

  /// `Spirit`
  String get spirit {
    return Intl.message('Spirit', name: 'spirit', desc: '', args: []);
  }

  /// `My Thoughts`
  String get myThoughts {
    return Intl.message('My Thoughts', name: 'myThoughts', desc: '', args: []);
  }

  /// `Verse for the Day`
  String get verseForTheDay {
    return Intl.message(
      'Verse for the Day',
      name: 'verseForTheDay',
      desc: '',
      args: [],
    );
  }

  /// `Today's Encouragement`
  String get todayEncouragement {
    return Intl.message(
      'Today\'s Encouragement',
      name: 'todayEncouragement',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load mood entry`
  String get unableToLoadMoodEntry {
    return Intl.message(
      'Unable to load mood entry',
      name: 'unableToLoadMoodEntry',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Delete Mood Entry`
  String get deleteMoodEntry {
    return Intl.message(
      'Delete Mood Entry',
      name: 'deleteMoodEntry',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this mood entry? This action cannot be undone.`
  String get deleteMoodEntryMessage {
    return Intl.message(
      'Are you sure you want to delete this mood entry? This action cannot be undone.',
      name: 'deleteMoodEntryMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Deleting...`
  String get deleting {
    return Intl.message('Deleting...', name: 'deleting', desc: '', args: []);
  }

  /// `Mood entry deleted successfully`
  String get moodEntryDeleted {
    return Intl.message(
      'Mood entry deleted successfully',
      name: 'moodEntryDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting mood entry`
  String get errorDeletingMoodEntry {
    return Intl.message(
      'Error deleting mood entry',
      name: 'errorDeletingMoodEntry',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Saving...`
  String get saving {
    return Intl.message('Saving...', name: 'saving', desc: '', args: []);
  }

  /// `Mood entry updated successfully`
  String get moodEntryUpdated {
    return Intl.message(
      'Mood entry updated successfully',
      name: 'moodEntryUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Error updating mood entry`
  String get errorUpdatingMoodEntry {
    return Intl.message(
      'Error updating mood entry',
      name: 'errorUpdatingMoodEntry',
      desc: '',
      args: [],
    );
  }

  /// `Select a Period`
  String get selectAPeriod {
    return Intl.message(
      'Select a Period',
      name: 'selectAPeriod',
      desc: '',
      args: [],
    );
  }

  /// `You've logged entries on {days} days`
  String youveLoggedEntriesOnDays(int days) {
    return Intl.message(
      'You\'ve logged entries on $days days',
      name: 'youveLoggedEntriesOnDays',
      desc: '',
      args: [days],
    );
  }

  /// `My Emotion`
  String get myEmotion {
    return Intl.message('My Emotion', name: 'myEmotion', desc: '', args: []);
  }

  /// `My Spirit`
  String get mySpirit {
    return Intl.message('My Spirit', name: 'mySpirit', desc: '', args: []);
  }

  /// `Streak Days`
  String get streakDays {
    return Intl.message('Streak Days', name: 'streakDays', desc: '', args: []);
  }

  /// `Days With Activity`
  String get daysWithActivity {
    return Intl.message(
      'Days With Activity',
      name: 'daysWithActivity',
      desc: '',
      args: [],
    );
  }

  /// `Start logging your moods to see your stats`
  String get startLoggingYourMoodsToSeeYourStats {
    return Intl.message(
      'Start logging your moods to see your stats',
      name: 'startLoggingYourMoodsToSeeYourStats',
      desc: '',
      args: [],
    );
  }

  /// `Add Mood Entry`
  String get addMoodEntry {
    return Intl.message(
      'Add Mood Entry',
      name: 'addMoodEntry',
      desc: '',
      args: [],
    );
  }

  /// `Premium`
  String get premium {
    return Intl.message('Premium', name: 'premium', desc: '', args: []);
  }

  /// `User`
  String get user {
    return Intl.message('User', name: 'user', desc: '', args: []);
  }

  /// `Emotional Mood Summary`
  String get emotionalMoodSummary {
    return Intl.message(
      'Emotional Mood Summary',
      name: 'emotionalMoodSummary',
      desc: '',
      args: [],
    );
  }

  /// `You felt most often: `
  String get youFeltMostOften {
    return Intl.message(
      'You felt most often: ',
      name: 'youFeltMostOften',
      desc: '',
      args: [],
    );
  }

  /// `Spiritual Mood Summary`
  String get spiritualMoodSummary {
    return Intl.message(
      'Spiritual Mood Summary',
      name: 'spiritualMoodSummary',
      desc: '',
      args: [],
    );
  }

  /// `Predominant spiritual mood: `
  String get predominantSpiritualMood {
    return Intl.message(
      'Predominant spiritual mood: ',
      name: 'predominantSpiritualMood',
      desc: '',
      args: [],
    );
  }

  /// `Unlock Premium to get access to all stats and features`
  String get unlockPremiumToGetAccessToAllStatsAndFeatures {
    return Intl.message(
      'Unlock Premium to get access to all stats and features',
      name: 'unlockPremiumToGetAccessToAllStatsAndFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Lighting your inner light`
  String get streakStatusLightingInnerLight {
    return Intl.message(
      'Lighting your inner light',
      name: 'streakStatusLightingInnerLight',
      desc: '',
      args: [],
    );
  }

  /// `Seed of faith`
  String get streakStatusSeedOfFaith {
    return Intl.message(
      'Seed of faith',
      name: 'streakStatusSeedOfFaith',
      desc: '',
      args: [],
    );
  }

  /// `Starting to grow`
  String get streakStatusStartingToGrow {
    return Intl.message(
      'Starting to grow',
      name: 'streakStatusStartingToGrow',
      desc: '',
      args: [],
    );
  }

  /// `Constant growth`
  String get streakStatusConstantGrowth {
    return Intl.message(
      'Constant growth',
      name: 'streakStatusConstantGrowth',
      desc: '',
      args: [],
    );
  }

  /// `Foundation in Christ`
  String get streakStatusFoundationInChrist {
    return Intl.message(
      'Foundation in Christ',
      name: 'streakStatusFoundationInChrist',
      desc: '',
      args: [],
    );
  }

  /// `Discipline in prayer`
  String get streakStatusDisciplineInPrayer {
    return Intl.message(
      'Discipline in prayer',
      name: 'streakStatusDisciplineInPrayer',
      desc: '',
      args: [],
    );
  }

  /// `Peace of the Holy Spirit`
  String get streakStatusPeaceOfHolySpirit {
    return Intl.message(
      'Peace of the Holy Spirit',
      name: 'streakStatusPeaceOfHolySpirit',
      desc: '',
      args: [],
    );
  }

  /// `Fed by the Word`
  String get streakStatusFedByTheWord {
    return Intl.message(
      'Fed by the Word',
      name: 'streakStatusFedByTheWord',
      desc: '',
      args: [],
    );
  }

  /// `Firm and deep faith`
  String get streakStatusFirmAndDeepFaith {
    return Intl.message(
      'Firm and deep faith',
      name: 'streakStatusFirmAndDeepFaith',
      desc: '',
      args: [],
    );
  }

  /// `Perseverance to the end`
  String get streakStatusPerseveranceToTheEnd {
    return Intl.message(
      'Perseverance to the end',
      name: 'streakStatusPerseveranceToTheEnd',
      desc: '',
      args: [],
    );
  }

  /// `Grateful heart`
  String get streakStatusGratefulHeart {
    return Intl.message(
      'Grateful heart',
      name: 'streakStatusGratefulHeart',
      desc: '',
      args: [],
    );
  }

  /// `Victory of the month`
  String get streakStatusVictoryOfTheMonth {
    return Intl.message(
      'Victory of the month',
      name: 'streakStatusVictoryOfTheMonth',
      desc: '',
      args: [],
    );
  }

  /// `Expanding faith`
  String get streakStatusExpandingFaith {
    return Intl.message(
      'Expanding faith',
      name: 'streakStatusExpandingFaith',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load devotional`
  String get unableToLoadDevotional {
    return Intl.message(
      'Unable to load devotional',
      name: 'unableToLoadDevotional',
      desc: '',
      args: [],
    );
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
