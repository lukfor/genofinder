process MERGE_VCF_FILES {

  publishDir "${params.outdir}", mode: 'copy', pattern: '*.vcf.gz'

  input:
  path vcf_files

  output:
  path "${params.project}.vcf.gz", emit: vcf_file

  """
  # if contains a spaceh --> multiple files --> merge needed
  if [[ "${vcf_files}" = *" "* ]]; then
    bcftools merge -m id ${vcf_files} -o ${params.project}.vcf.gz -Oz
    tabix ${params.project}.vcf.gz
  else
    cp ${vcf_files} ${params.project}.vcf.gz
  fi

  """

}
