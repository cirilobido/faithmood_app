

enum Lang {
  en, // English
  es, // Español
  pt; // Português

  const Lang();

  static String? toTitle({
    required Lang? value,
  }) {
    if (value == null) return null;
    switch (value) {
      case Lang.en:
        return "English";
      case Lang.es:
        return "Español";
      case Lang.pt:
        return "Português";
    }
  }
}