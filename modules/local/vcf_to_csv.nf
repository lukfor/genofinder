process VCF_TO_CSV {

  publishDir "${params.outdir}", mode: 'copy', pattern: '*.csv'

  input:
  path vcf_file
  val genotypes

  output:
  path "*.csv", emit: csv_file

  """
  java -jar /opt/genomic-utils.jar \
    vcf-to-csv \
    --input ${vcf_file} \
    --output ${params.project}.${genotypes}.csv \
    --format csv \
    --genotypes ${genotypes}
  """

}
