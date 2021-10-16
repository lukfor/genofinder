process EXTRACT_REGIONS_FROM_VCF {

  input:
    path regions_file
    tuple val(filename), path(vcf_file)

  output:
    path "*.vcf.gz", emit: vcf_file

  """
  bcftools view -R ${regions_file} ${filename}.vcf.gz -o ${filename}.regions.vcf.gz -Oz
  """

}
