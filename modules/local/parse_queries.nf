process PARSE_QUERIES {

  publishDir "${params.outdir}", mode: 'copy', pattern: '*.bed'

  input:
    path queries_file
    path script

  output:
    path "${params.project}.bed", emit: bed_file

  """
  jbang ${script} --input ${queries_file} --output ${params.project}.bed
  """

}
