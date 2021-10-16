process CACHE_JBANG_SCRIPTS {

  input:
    path vcf_to_csv_java
    path vcf_to_csv_transpose_java

  output:
    path "VcfToCsv.jar", emit: vcf_to_csv_jar
    path "VcfToCsvTranspose.jar", emit: vcf_to_csv_transpose_jar

  """
  jbang export portable -O=VcfToCsv.jar ${vcf_to_csv_java}
  jbang export portable -O=VcfToCsvTranspose.jar ${vcf_to_csv_transpose_java}
  """

}
