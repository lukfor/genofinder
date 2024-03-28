process VCF_TO_CSV_TRANSPOSE {

  publishDir "${params.outdir}", mode: 'copy', pattern: '*.csv'

  input:
  path vcf_file
  val genotypes

  output:
  path "*.csv", emit: csv_file

  """
  java -jar /opt/genomic-utils.jar \
    vcf-to-csv-transpose \
    --input ${vcf_file} \
    --output ${params.project}.${genotypes}.transpose.csv \
    --format csv \
    --genotypes ${genotypes} \
    --name id
  """

}
