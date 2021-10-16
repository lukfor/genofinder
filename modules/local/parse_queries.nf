process PARSE_QUERIES {

  publishDir "${params.outdir}", mode: 'copy', pattern: '*.bed'

  input:
    path queries_file

  output:
    path "${params.project}.bed", emit: bed_file

  """
  cp ${queries_file} ${params.project}.bed
  """

}
