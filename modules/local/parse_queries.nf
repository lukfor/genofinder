process PARSE_QUERIES {

  publishDir "${params.outdir}", mode: 'copy', pattern: '*.bed'

  input:
    path queries_file
    tuple val(rsids_name), path(rsids_vcf), path(rsids_index)
 

  output:
    path "${params.project}.bed", emit: bed_file

  script:
    def dbsnp_param = (params.rsids != null ? "--dbsnp ${rsids_vcf}" : "")

  """
  java -jar /opt/genomic-utils.jar \
    csv-to-bed \
    --input ${queries_file} \
    --output ${params.project}.bed \
    --build ${params.genotypes_build} \
    ${dbsnp_param}

  """

}
