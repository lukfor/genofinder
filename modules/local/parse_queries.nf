process PARSE_QUERIES {

  publishDir "${params.outdir}", mode: 'copy', pattern: '*.bed'

  input:
    path queries_file

  output:
    path "${params.project}.bed", emit: bed_file

  """
  java -jar /opt/genomic-utils.jar \
    csv-to-bed \
    --input ${queries_file} \
    --output ${params.project}.bed \
    --build ${params.genotypes_build}

  """

}
