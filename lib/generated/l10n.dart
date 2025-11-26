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

  /// `This field is required.`
  String get thisFieldIsRequired {
    return Intl.message(
      'This field is required.',
      name: 'thisFieldIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Your password must contain at least:`
  String get passwordMustContainAtLeast {
    return Intl.message(
      'Your password must contain at least:',
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

  /// `Please enter a valid email address.`
  String get youHaveToEnterAValidEmail {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'youHaveToEnterAValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Your name must be at least 3 characters long.`
  String get nameMustBeAtLeast3CharactersLong {
    return Intl.message(
      'Your name must be at least 3 characters long.',
      name: 'nameMustBeAtLeast3CharactersLong',
      desc: '',
      args: [],
    );
  }

  /// `Your email or password seems incorrect. Please check your details and try again.`
  String get invalidEmailOrPasswordPleaseTryAgain {
    return Intl.message(
      'Your email or password seems incorrect. Please check your details and try again.',
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

  /// `Forgot your password?`
  String get forgotYourPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgotYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `We'll send a code to your email so you can reset your password.`
  String get weWillSendYouAnEmailWithACodeTo {
    return Intl.message(
      'We\'ll send a code to your email so you can reset your password.',
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

  /// `We’ve sent a 6-digit code to the email you provided. This code will expire in 5 minutes.`
  String get verifyCodeMessage {
    return Intl.message(
      'We’ve sent a 6-digit code to the email you provided. This code will expire in 5 minutes.',
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

  /// `Your password has been reset successfully.`
  String get passwordRestoredSuccessfully {
    return Intl.message(
      'Your password has been reset successfully.',
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

  /// `We couldn’t verify your code. Please check it and try again.`
  String get verificationFailedMessage {
    return Intl.message(
      'We couldn’t verify your code. Please check it and try again.',
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

  /// `never stored`
  String get neverStored {
    return Intl.message(
      'never stored',
      name: 'neverStored',
      desc: '',
      args: [],
    );
  }

  /// `in the app.`
  String get inTheApp {
    return Intl.message('in the app.', name: 'inTheApp', desc: '', args: []);
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message('Try Again', name: 'tryAgain', desc: '', args: []);
  }

  /// `Sign In`
  String get signIn {
    return Intl.message('Sign In', name: 'signIn', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Your email or password doesn’t match. Please review your details and try again.`
  String get loginErrorMessage {
    return Intl.message(
      'Your email or password doesn’t match. Please review your details and try again.',
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

  /// `Your information will remain private and secure.`
  String get informationSafeMessage {
    return Intl.message(
      'Your information will remain private and secure.',
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

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `The phone number can only contain digits.`
  String get phoneNumberDigitsError {
    return Intl.message(
      'The phone number can only contain digits.',
      name: 'phoneNumberDigitsError',
      desc: '',
      args: [],
    );
  }

  /// `The phone number must be between 10 and 15 digits long.`
  String get phoneNumberLengthError {
    return Intl.message(
      'The phone number must be between 10 and 15 digits long.',
      name: 'phoneNumberLengthError',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordDontMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordDontMatch',
      desc: '',
      args: [],
    );
  }

  /// `You’re almost there — just add your credentials to sign in.`
  String get signUpEmailMessage {
    return Intl.message(
      'You’re almost there — just add your credentials to sign in.',
      name: 'signUpEmailMessage',
      desc: '',
      args: [],
    );
  }

  /// `Or sign in with`
  String get orLoginWith {
    return Intl.message(
      'Or sign in with',
      name: 'orLoginWith',
      desc: '',
      args: [],
    );
  }

  /// `Hello, welcome back!`
  String get loginGreetingMessage {
    return Intl.message(
      'Hello, welcome back!',
      name: 'loginGreetingMessage',
      desc: '',
      args: [],
    );
  }

  /// `One uppercase letter`
  String get passOneUppercaseLetter {
    return Intl.message(
      'One uppercase letter',
      name: 'passOneUppercaseLetter',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get search {
    return Intl.message('Search...', name: 'search', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
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

  /// `A place to connect with your heart and with God every day.`
  String get welcomeSubtitle {
    return Intl.message(
      'A place to connect with your heart and with God every day.',
      name: 'welcomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Let's build your profile.`
  String get profilePageTitle {
    return Intl.message(
      'Let\'s build your profile.',
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

  /// `💭 What would you like to experience on this journey?`
  String get experiencePageTitle {
    return Intl.message(
      '💭 What would you like to experience on this journey?',
      name: 'experiencePageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Select your language`
  String get selectYourLanguage {
    return Intl.message(
      'Select your language',
      name: 'selectYourLanguage',
      desc: '',
      args: [],
    );
  }

  /// `🕊️ Find inner peace`
  String get experienceQ1 {
    return Intl.message(
      '🕊️ Find inner peace',
      name: 'experienceQ1',
      desc: '',
      args: [],
    );
  }

  /// `💭 Learn to understand your moods`
  String get experienceQ2 {
    return Intl.message(
      '💭 Learn to understand your moods',
      name: 'experienceQ2',
      desc: '',
      args: [],
    );
  }

  /// `🙏 Strengthen your faith`
  String get experienceQ3 {
    return Intl.message(
      '🙏 Strengthen your faith',
      name: 'experienceQ3',
      desc: '',
      args: [],
    );
  }

  /// `✨ Have a daily moment with God`
  String get experienceQ4 {
    return Intl.message(
      '✨ Have a daily moment with God',
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

  /// `🙌 How committed are you to your faith?`
  String get committedPageTitle {
    return Intl.message(
      '🙌 How committed are you to your faith?',
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

  /// `🌿 Have you used a faith journal app before?`
  String get everUsedBeforeTitle {
    return Intl.message(
      '🌿 Have you used a faith journal app before?',
      name: 'everUsedBeforeTitle',
      desc: '',
      args: [],
    );
  }

  /// `🙏 Yes, I have used one`
  String get everUsedBeforeQ1 {
    return Intl.message(
      '🙏 Yes, I have used one',
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

  /// `Over 80% of those who use FaithMood feel their faith grow within 30 days.`
  String get joinOthersSubtitle {
    return Intl.message(
      'Over 80% of those who use FaithMood feel their faith grow within 30 days.',
      name: 'joinOthersSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `📖 Have you ever followed a guided faith plan?`
  String get guidedPlanTitle {
    return Intl.message(
      '📖 Have you ever followed a guided faith plan?',
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

  /// `We’ll gently remind you of your reflections, prayers, and devotionals — only when it truly matters.`
  String get askNotificationSubtitle {
    return Intl.message(
      'We’ll gently remind you of your reflections, prayers, and devotionals — only when it truly matters.',
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

  /// `The Lord gives strength when it’s needed most.`
  String get preparingPageSubtitle {
    return Intl.message(
      'The Lord gives strength when it’s needed most.',
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

  /// `Adding final touches...`
  String get preparingPageT3 {
    return Intl.message(
      'Adding final touches...',
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

  /// `Just ### per month — cancel anytime`
  String get just449PerMonthCancelAnytime {
    return Intl.message(
      'Just ### per month — cancel anytime',
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

  /// `Discover a calm, ad-free space designed to nurture your faith with reflection and growth.`
  String get paywallSubtitle {
    return Intl.message(
      'Discover a calm, ad-free space designed to nurture your faith with reflection and growth.',
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
  String get psalm231Verse {
    return Intl.message(
      'The Lord is my shepherd; I shall not want.',
      name: 'psalm231Verse',
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

  /// `✨ Advanced Progress Tracker`
  String get advanceProgressTracker {
    return Intl.message(
      '✨ Advanced Progress Tracker',
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

  /// `✨ Your journey begins today`
  String get yourJourneyBeginsToday {
    return Intl.message(
      '✨ Your journey begins today',
      name: 'yourJourneyBeginsToday',
      desc: '',
      args: [],
    );
  }

  /// `Unlock more devotionals, deeper stats, and an ad-free experience.`
  String get unlockMoreDevotionalsAdvanceStats {
    return Intl.message(
      'Unlock more devotionals, deeper stats, and an ad-free experience.',
      name: 'unlockMoreDevotionalsAdvanceStats',
      desc: '',
      args: [],
    );
  }

  /// `Discover Premium`
  String get discoverPremium {
    return Intl.message(
      'Discover Premium',
      name: 'discoverPremium',
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

  /// `Your feedback can inspire others 🙏`
  String get ratingContentSubtitle {
    return Intl.message(
      'Your feedback can inspire others 🙏',
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

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `No tags available`
  String get noTagsAvailable {
    return Intl.message(
      'No tags available',
      name: 'noTagsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Unlock Now`
  String get unlockNow {
    return Intl.message('Unlock Now', name: 'unlockNow', desc: '', args: []);
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

  /// `Verse of the Day`
  String get verseOfTheDay {
    return Intl.message(
      'Verse of the Day',
      name: 'verseOfTheDay',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load the verse right now. Please try again later.`
  String get unableToLoadVersePleaseTryAgainLater {
    return Intl.message(
      'Unable to load the verse right now. Please try again later.',
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

  /// `Follow guided daily devotionals`
  String get followGuidedDailyDevotionals {
    return Intl.message(
      'Follow guided daily devotionals',
      name: 'followGuidedDailyDevotionals',
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

  /// `Unable to load devotionals.`
  String get unableToLoadDevotionals {
    return Intl.message(
      'Unable to load devotionals.',
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

  /// `Note saved successfully.`
  String get noteSavedSuccessfully {
    return Intl.message(
      'Note saved successfully.',
      name: 'noteSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error saving your note.`
  String get errorSavingNote {
    return Intl.message(
      'Error saving your note.',
      name: 'errorSavingNote',
      desc: '',
      args: [],
    );
  }

  /// `Your Spiritual Mood`
  String get whereIsYourHeartToday {
    return Intl.message(
      'Your Spiritual Mood',
      name: 'whereIsYourHeartToday',
      desc: '',
      args: [],
    );
  }

  /// `Select how you feel right now. Be honest with yourself.`
  String get chooseMoodThatBestReflects {
    return Intl.message(
      'Select how you feel right now. Be honest with yourself.',
      name: 'chooseMoodThatBestReflects',
      desc: '',
      args: [],
    );
  }

  /// `Choose the mood of your heart before God.`
  String get selectStateThatResonates {
    return Intl.message(
      'Choose the mood of your heart before God.',
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

  /// `Write what’s on your heart — your feelings, your prayers, or what you learned today.`
  String get writeWhatsOnYourHeart {
    return Intl.message(
      'Write what’s on your heart — your feelings, your prayers, or what you learned today.',
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

  /// `You can revisit this note anytime in your Journal.`
  String get youCanRevisitThisNote {
    return Intl.message(
      'You can revisit this note anytime in your Journal.',
      name: 'youCanRevisitThisNote',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load moods.`
  String get unableToLoadMoods {
    return Intl.message(
      'Unable to load moods.',
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

  /// `How are you feeling?`
  String get howAreYouFeeling {
    return Intl.message(
      'How are you feeling?',
      name: 'howAreYouFeeling',
      desc: '',
      args: [],
    );
  }

  /// `Log Mood`
  String get logMood {
    return Intl.message('Log Mood', name: 'logMood', desc: '', args: []);
  }

  /// `Select an emotional mood.`
  String get pleaseSelectEmotionalMood {
    return Intl.message(
      'Select an emotional mood.',
      name: 'pleaseSelectEmotionalMood',
      desc: '',
      args: [],
    );
  }

  /// `Select a spiritual mood.`
  String get pleaseSelectSpiritualMood {
    return Intl.message(
      'Select a spiritual mood.',
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

  /// `Finding the verse meant for your moment...`
  String get searchingForVerse {
    return Intl.message(
      'Finding the verse meant for your moment...',
      name: 'searchingForVerse',
      desc: '',
      args: [],
    );
  }

  /// `Preparing your guidance...`
  String get preparingLearning {
    return Intl.message(
      'Preparing your guidance...',
      name: 'preparingLearning',
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

  /// `Moods`
  String get moods {
    return Intl.message('Moods', name: 'moods', desc: '', args: []);
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

  /// `No journal entries.`
  String get noJournalEntries {
    return Intl.message(
      'No journal entries.',
      name: 'noJournalEntries',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load journal entries.`
  String get unableToLoadJournalEntries {
    return Intl.message(
      'Unable to load journal entries.',
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

  /// `No emotional moods available.`
  String get noEmotionalMoodsAvailable {
    return Intl.message(
      'No emotional moods available.',
      name: 'noEmotionalMoodsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No spiritual moods available.`
  String get noSpiritualMoodsAvailable {
    return Intl.message(
      'No spiritual moods available.',
      name: 'noSpiritualMoodsAvailable',
      desc: '',
      args: [],
    );
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

  /// `Today's Encouragement`
  String get todayEncouragement {
    return Intl.message(
      'Today\'s Encouragement',
      name: 'todayEncouragement',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load mood entry.`
  String get unableToLoadMoodEntry {
    return Intl.message(
      'Unable to load mood entry.',
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

  /// `Mood entry deleted successfully.`
  String get moodEntryDeleted {
    return Intl.message(
      'Mood entry deleted successfully.',
      name: 'moodEntryDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting mood entry.`
  String get errorDeletingMoodEntry {
    return Intl.message(
      'Error deleting mood entry.',
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

  /// `Mood entry updated successfully.`
  String get moodEntryUpdated {
    return Intl.message(
      'Mood entry updated successfully.',
      name: 'moodEntryUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Error updating mood entry.`
  String get errorUpdatingMoodEntry {
    return Intl.message(
      'Error updating mood entry.',
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

  /// `Days With Activity`
  String get daysWithActivity {
    return Intl.message(
      'Days With Activity',
      name: 'daysWithActivity',
      desc: '',
      args: [],
    );
  }

  /// `Start logging your moods to see your stats.`
  String get startLoggingYourMoodsToSeeYourStats {
    return Intl.message(
      'Start logging your moods to see your stats.',
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

  /// `Profile`
  String get user {
    return Intl.message('Profile', name: 'user', desc: '', args: []);
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

  /// `Unlock Premium to access all statistics and features.`
  String get unlockPremiumToGetAccessToAllStatsAndFeatures {
    return Intl.message(
      'Unlock Premium to access all statistics and features.',
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

  /// `Unable to load devotional.`
  String get unableToLoadDevotional {
    return Intl.message(
      'Unable to load devotional.',
      name: 'unableToLoadDevotional',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Personal Information`
  String get personalInformation {
    return Intl.message(
      'Personal Information',
      name: 'personalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Privacy & Security`
  String get privacySecurity {
    return Intl.message(
      'Privacy & Security',
      name: 'privacySecurity',
      desc: '',
      args: [],
    );
  }

  /// `Current Subscription`
  String get currentSubscription {
    return Intl.message(
      'Current Subscription',
      name: 'currentSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Customization`
  String get customization {
    return Intl.message(
      'Customization',
      name: 'customization',
      desc: '',
      args: [],
    );
  }

  /// `Reminder Alert`
  String get reminderAlert {
    return Intl.message(
      'Reminder Alert',
      name: 'reminderAlert',
      desc: '',
      args: [],
    );
  }

  /// `App Language`
  String get appLanguage {
    return Intl.message(
      'App Language',
      name: 'appLanguage',
      desc: '',
      args: [],
    );
  }

  /// `App Theme`
  String get appTheme {
    return Intl.message('App Theme', name: 'appTheme', desc: '', args: []);
  }

  /// `Select your theme`
  String get selectYourTheme {
    return Intl.message(
      'Select your theme',
      name: 'selectYourTheme',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `System`
  String get system {
    return Intl.message('System', name: 'system', desc: '', args: []);
  }

  /// `Our App`
  String get ourApp {
    return Intl.message('Our App', name: 'ourApp', desc: '', args: []);
  }

  /// `Rate Us`
  String get rateUs {
    return Intl.message('Rate Us', name: 'rateUs', desc: '', args: []);
  }

  /// `Share App`
  String get shareApp {
    return Intl.message('Share App', name: 'shareApp', desc: '', args: []);
  }

  /// `Follow Us`
  String get followUs {
    return Intl.message('Follow Us', name: 'followUs', desc: '', args: []);
  }

  /// `Support`
  String get support {
    return Intl.message('Support', name: 'support', desc: '', args: []);
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message('Contact Us', name: 'contactUs', desc: '', args: []);
  }

  /// `Terms & Conditions`
  String get termsConditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'termsConditions',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logOut {
    return Intl.message('Log Out', name: 'logOut', desc: '', args: []);
  }

  /// `Are you sure you want to log out?`
  String get areYouSureYouWantToLogOut {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'areYouSureYouWantToLogOut',
      desc: '',
      args: [],
    );
  }

  /// `App Version: ###`
  String get appVersionStateappversion {
    return Intl.message(
      'App Version: ###',
      name: 'appVersionStateappversion',
      desc: '',
      args: [],
    );
  }

  /// `Unlock Premium Features`
  String get unlockPremiumFeatures {
    return Intl.message(
      'Unlock Premium Features',
      name: 'unlockPremiumFeatures',
      desc: '',
      args: [],
    );
  }

  /// `FaithMood App`
  String get shareFaithMoodApp {
    return Intl.message(
      'FaithMood App',
      name: 'shareFaithMoodApp',
      desc: '',
      args: [],
    );
  }

  /// `FaithMood App\nFaithMood helps you reflect on your emotions, strengthen your spiritual life, and receive guided devotionals made for your journey.\nYou should try it 👉 ###`
  String get shareFaithMoodAppMessage {
    return Intl.message(
      'FaithMood App\nFaithMood helps you reflect on your emotions, strengthen your spiritual life, and receive guided devotionals made for your journey.\nYou should try it 👉 ###',
      name: 'shareFaithMoodAppMessage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get localeName {
    return Intl.message('English', name: 'localeName', desc: '', args: []);
  }

  /// `FaithMood`
  String get appName {
    return Intl.message('FaithMood', name: 'appName', desc: '', args: []);
  }

  /// `This is used for all your mood analysis.`
  String get thisUsedForAllYourMoodAnalysis {
    return Intl.message(
      'This is used for all your mood analysis.',
      name: 'thisUsedForAllYourMoodAnalysis',
      desc: '',
      args: [],
    );
  }

  /// `Update Information`
  String get updateInformation {
    return Intl.message(
      'Update Information',
      name: 'updateInformation',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all fields with valid information.`
  String get pleaseFillAllTheFieldsWithValidData {
    return Intl.message(
      'Please fill all fields with valid information.',
      name: 'pleaseFillAllTheFieldsWithValidData',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong while updating your information. Please try again.`
  String get sorrySomethingWentWrongWhileUpdatingYourInformationPleaseTry {
    return Intl.message(
      'Something went wrong while updating your information. Please try again.',
      name: 'sorrySomethingWentWrongWhileUpdatingYourInformationPleaseTry',
      desc: '',
      args: [],
    );
  }

  /// `After deleting your account, you will lose all your data. This action cannot be undone.`
  String get afterDeletingYourAccountYouWillLoseAllYourData {
    return Intl.message(
      'After deleting your account, you will lose all your data. This action cannot be undone.',
      name: 'afterDeletingYourAccountYouWillLoseAllYourData',
      desc: '',
      args: [],
    );
  }

  /// `Your information has been updated successfully.`
  String get informationUpdatedSuccessfully {
    return Intl.message(
      'Your information has been updated successfully.',
      name: 'informationUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error updating your information. Please try again.`
  String get errorUpdatingInformation {
    return Intl.message(
      'Error updating your information. Please try again.',
      name: 'errorUpdatingInformation',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting your account. Please try again.`
  String get errorDeletingAccount {
    return Intl.message(
      'Error deleting your account. Please try again.',
      name: 'errorDeletingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get reminder {
    return Intl.message('Reminder', name: 'reminder', desc: '', args: []);
  }

  /// `Set a daily reminder to stay connected with your faith journey.`
  String get reminderMessage {
    return Intl.message(
      'Set a daily reminder to stay connected with your faith journey.',
      name: 'reminderMessage',
      desc: '',
      args: [],
    );
  }

  /// `Daily Faith Reminder`
  String get dailyDreamReminder {
    return Intl.message(
      'Daily Faith Reminder',
      name: 'dailyDreamReminder',
      desc: '',
      args: [],
    );
  }

  /// `Your daily reminder is set for this time each day.`
  String get reminderSetMessage {
    return Intl.message(
      'Your daily reminder is set for this time each day.',
      name: 'reminderSetMessage',
      desc: '',
      args: [],
    );
  }

  /// `Change Time`
  String get changeTime {
    return Intl.message('Change Time', name: 'changeTime', desc: '', args: []);
  }

  /// `Remove Reminder`
  String get removeReminder {
    return Intl.message(
      'Remove Reminder',
      name: 'removeReminder',
      desc: '',
      args: [],
    );
  }

  /// `You don’t have a reminder set yet. Set one to receive gentle daily prompts.`
  String get reminderNoSetMessage {
    return Intl.message(
      'You don’t have a reminder set yet. Set one to receive gentle daily prompts.',
      name: 'reminderNoSetMessage',
      desc: '',
      args: [],
    );
  }

  /// `Set Reminder`
  String get setReminder {
    return Intl.message(
      'Set Reminder',
      name: 'setReminder',
      desc: '',
      args: [],
    );
  }

  /// `Time to reflect 🙏`
  String get reminderNotificationTitle {
    return Intl.message(
      'Time to reflect 🙏',
      name: 'reminderNotificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Take a quiet moment to reflect, pray, or journal your mood for today.`
  String get reminderNotificationMessage {
    return Intl.message(
      'Take a quiet moment to reflect, pray, or journal your mood for today.',
      name: 'reminderNotificationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Your daily reminder is set`
  String get yourDailyReminderIsSet {
    return Intl.message(
      'Your daily reminder is set',
      name: 'yourDailyReminderIsSet',
      desc: '',
      args: [],
    );
  }

  /// `Reminder deleted successfully`
  String get reminderDeleted {
    return Intl.message(
      'Reminder deleted successfully',
      name: 'reminderDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Finish Account Setup`
  String get finishAccountSetup {
    return Intl.message(
      'Finish Account Setup',
      name: 'finishAccountSetup',
      desc: '',
      args: [],
    );
  }

  /// `Complete your profile by adding your email and password.`
  String get finishAccountSetupMessage {
    return Intl.message(
      'Complete your profile by adding your email and password.',
      name: 'finishAccountSetupMessage',
      desc: '',
      args: [],
    );
  }

  /// `Download FaithMood App: ###`
  String get downloadFaithmoodApp {
    return Intl.message(
      'Download FaithMood App: ###',
      name: 'downloadFaithmoodApp',
      desc: '',
      args: [],
    );
  }

  /// `When you feel ###, reflect on this verse:`
  String get whenYouFeelLookAtThisVerse {
    return Intl.message(
      'When you feel ###, reflect on this verse:',
      name: 'whenYouFeelLookAtThisVerse',
      desc: '',
      args: [],
    );
  }

  /// `Vibration`
  String get vibration {
    return Intl.message('Vibration', name: 'vibration', desc: '', args: []);
  }

  /// `Good morning`
  String get greetingMorning {
    return Intl.message(
      'Good morning',
      name: 'greetingMorning',
      desc: '',
      args: [],
    );
  }

  /// `Good afternoon`
  String get greetingAfternoon {
    return Intl.message(
      'Good afternoon',
      name: 'greetingAfternoon',
      desc: '',
      args: [],
    );
  }

  /// `Good evening`
  String get greetingEvening {
    return Intl.message(
      'Good evening',
      name: 'greetingEvening',
      desc: '',
      args: [],
    );
  }

  /// `Start your day with a calm heart.`
  String get greetingMorningSubtitle1 {
    return Intl.message(
      'Start your day with a calm heart.',
      name: 'greetingMorningSubtitle1',
      desc: '',
      args: [],
    );
  }

  /// `God is near — breathe and welcome the morning.`
  String get greetingMorningSubtitle2 {
    return Intl.message(
      'God is near — breathe and welcome the morning.',
      name: 'greetingMorningSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `Let His peace guide your first steps today.`
  String get greetingMorningSubtitle3 {
    return Intl.message(
      'Let His peace guide your first steps today.',
      name: 'greetingMorningSubtitle3',
      desc: '',
      args: [],
    );
  }

  /// `Your heart awakens with purpose.`
  String get greetingMorningSubtitle4 {
    return Intl.message(
      'Your heart awakens with purpose.',
      name: 'greetingMorningSubtitle4',
      desc: '',
      args: [],
    );
  }

  /// `May this morning bring light to your soul.`
  String get greetingMorningSubtitle5 {
    return Intl.message(
      'May this morning bring light to your soul.',
      name: 'greetingMorningSubtitle5',
      desc: '',
      args: [],
    );
  }

  /// `Stay steady — God walks with you.`
  String get greetingAfternoonSubtitle1 {
    return Intl.message(
      'Stay steady — God walks with you.',
      name: 'greetingAfternoonSubtitle1',
      desc: '',
      args: [],
    );
  }

  /// `Let peace lead your afternoon.`
  String get greetingAfternoonSubtitle2 {
    return Intl.message(
      'Let peace lead your afternoon.',
      name: 'greetingAfternoonSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `Your journey continues with grace.`
  String get greetingAfternoonSubtitle3 {
    return Intl.message(
      'Your journey continues with grace.',
      name: 'greetingAfternoonSubtitle3',
      desc: '',
      args: [],
    );
  }

  /// `Take a moment to breathe and recentre.`
  String get greetingAfternoonSubtitle4 {
    return Intl.message(
      'Take a moment to breathe and recentre.',
      name: 'greetingAfternoonSubtitle4',
      desc: '',
      args: [],
    );
  }

  /// `Strength for the rest of your day.`
  String get greetingAfternoonSubtitle5 {
    return Intl.message(
      'Strength for the rest of your day.',
      name: 'greetingAfternoonSubtitle5',
      desc: '',
      args: [],
    );
  }

  /// `Release your worries — God holds your night.`
  String get greetingEveningSubtitle1 {
    return Intl.message(
      'Release your worries — God holds your night.',
      name: 'greetingEveningSubtitle1',
      desc: '',
      args: [],
    );
  }

  /// `Rest your heart in His presence.`
  String get greetingEveningSubtitle2 {
    return Intl.message(
      'Rest your heart in His presence.',
      name: 'greetingEveningSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `You made it through today — breathe deeply.`
  String get greetingEveningSubtitle3 {
    return Intl.message(
      'You made it through today — breathe deeply.',
      name: 'greetingEveningSubtitle3',
      desc: '',
      args: [],
    );
  }

  /// `Find peace in the quiet of this evening.`
  String get greetingEveningSubtitle4 {
    return Intl.message(
      'Find peace in the quiet of this evening.',
      name: 'greetingEveningSubtitle4',
      desc: '',
      args: [],
    );
  }

  /// `Let your soul unwind in God’s care.`
  String get greetingEveningSubtitle5 {
    return Intl.message(
      'Let your soul unwind in God’s care.',
      name: 'greetingEveningSubtitle5',
      desc: '',
      args: [],
    );
  }

  /// `Journal`
  String get journal {
    return Intl.message('Journal', name: 'journal', desc: '', args: []);
  }

  /// `Faith`
  String get faith {
    return Intl.message('Faith', name: 'faith', desc: '', args: []);
  }

  /// `No moods available`
  String get noMoodsAvailable {
    return Intl.message(
      'No moods available',
      name: 'noMoodsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Has Note`
  String get hasNote {
    return Intl.message('Has Note', name: 'hasNote', desc: '', args: []);
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

  /// `Play`
  String get play {
    return Intl.message('Play', name: 'play', desc: '', args: []);
  }

  /// `Pause`
  String get pause {
    return Intl.message('Pause', name: 'pause', desc: '', args: []);
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `Add to favorites`
  String get addToFavorites {
    return Intl.message(
      'Add to favorites',
      name: 'addToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Remove from favorites`
  String get removeFromFavorites {
    return Intl.message(
      'Remove from favorites',
      name: 'removeFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `No voices available`
  String get noVoicesAvailable {
    return Intl.message(
      'No voices available',
      name: 'noVoicesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Select Voice`
  String get selectVoice {
    return Intl.message(
      'Select Voice',
      name: 'selectVoice',
      desc: '',
      args: [],
    );
  }

  /// `This Week`
  String get thisWeek {
    return Intl.message('This Week', name: 'thisWeek', desc: '', args: []);
  }

  /// `Last Week`
  String get lastWeek {
    return Intl.message('Last Week', name: 'lastWeek', desc: '', args: []);
  }

  /// `This Month`
  String get thisMonth {
    return Intl.message('This Month', name: 'thisMonth', desc: '', args: []);
  }

  /// `Last Month`
  String get lastMonth {
    return Intl.message('Last Month', name: 'lastMonth', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'pt'),
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
