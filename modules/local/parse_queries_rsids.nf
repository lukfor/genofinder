process PARSE_QUERIES_RSIDS {

  publishDir "${params.outdir}", mode: 'copy', pattern: '*.bed'

  input:
    path queries_file
    tuple val(rsids_name), path(rsids_txt), path(rsids_index)
 

  output:
    path "${params.project}.bed", emit: bed_file

  """
  java -jar /opt/genomic-utils.jar \
    csv-to-bed \
    --input ${queries_file} \
    --output ${params.project}.bed \
    --build ${params.genotypes_build} \
    --dbsnp ${rsids_txt}
  """

}
