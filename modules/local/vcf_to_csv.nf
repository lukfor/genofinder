process VCF_TO_CSV {

  publishDir "${params.outdir}", mode: 'copy', pattern: '*.csv'

  input:
  path vcf_file
  file script
  val genotypes

  output:
  path "*.csv", emit: csv_file

  """
  jbang ${script} --input ${vcf_file} --output ${params.project}.${genotypes}.csv --format csv --genotypes ${genotypes}
  """

}
