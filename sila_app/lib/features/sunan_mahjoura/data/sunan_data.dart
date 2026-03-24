class SunnahItem {
  final String textKey;
  final String sourceKey;
  final String explanationKey;

  const SunnahItem({
    required this.textKey, 
    required this.sourceKey,
    required this.explanationKey,
  });
}

final List<SunnahItem> sunanMahjouraList = [
   SunnahItem(
    textKey: "sunnah_1_text",
    sourceKey: "sunnah_1_source",
    explanationKey: "sunnah_1_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_2_text",
    sourceKey: "sunnah_2_source",
    explanationKey: "sunnah_2_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_3_text",
    sourceKey: "sunnah_3_source",
    explanationKey: "sunnah_3_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_4_text",
    sourceKey: "sunnah_4_source",
    explanationKey: "sunnah_4_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_5_text",
    sourceKey: "sunnah_5_source",
    explanationKey: "sunnah_5_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_6_text",
    sourceKey: "sunnah_6_source",
    explanationKey: "sunnah_6_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_7_text",
    sourceKey: "sunnah_7_source",
    explanationKey: "sunnah_7_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_8_text",
    sourceKey: "sunnah_8_source",
    explanationKey: "sunnah_8_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_9_text",
    sourceKey: "sunnah_9_source",
    explanationKey: "sunnah_9_explanation",
  ),
   SunnahItem(
    textKey: "sunnah_10_text",
    sourceKey: "sunnah_10_source",
    explanationKey: "sunnah_10_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_11_text",
    sourceKey: "sunnah_11_source",
    explanationKey: "sunnah_11_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_12_text",
    sourceKey: "sunnah_12_source",
    explanationKey: "sunnah_12_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_13_text",
    sourceKey: "sunnah_13_source",
    explanationKey: "sunnah_13_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_14_text",
    sourceKey: "sunnah_14_source",
    explanationKey: "sunnah_14_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_15_text",
    sourceKey: "sunnah_15_source",
    explanationKey: "sunnah_15_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_16_text",
    sourceKey: "sunnah_16_source",
    explanationKey: "sunnah_16_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_17_text",
    sourceKey: "sunnah_17_source",
    explanationKey: "sunnah_17_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_18_text",
    sourceKey: "sunnah_18_source",
    explanationKey: "sunnah_18_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_19_text",
    sourceKey: "sunnah_19_source",
    explanationKey: "sunnah_19_explanation",
  ),
   SunnahItem(
    textKey: "sunnah_20_text",
    sourceKey: "sunnah_20_source",
    explanationKey: "sunnah_20_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_21_text",
    sourceKey: "sunnah_21_source",
    explanationKey: "sunnah_21_explanation",
  ),
   SunnahItem(
    textKey: "sunnah_22_text",
    sourceKey: "sunnah_22_source",
    explanationKey: "sunnah_22_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_23_text",
    sourceKey: "sunnah_23_source",
    explanationKey: "sunnah_23_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_24_text",
    sourceKey: "sunnah_24_source",
    explanationKey: "sunnah_24_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_25_text",
    sourceKey: "sunnah_25_source",
    explanationKey: "sunnah_25_explanation",
  ),
  SunnahItem(
    textKey: "sunnah_26_text",
    sourceKey: "sunnah_26_source",
    explanationKey: "sunnah_26_explanation",
  ),
];

SunnahItem getTodaySunnah() {
  final now = DateTime.now();
  // Using day of year to rotate through the list
  final dayOfYear = int.parse("${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}");
  
  // Simple hashing or index calculation
  final index = dayOfYear % sunanMahjouraList.length;
  return sunanMahjouraList[index];
}
