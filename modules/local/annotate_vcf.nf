process ANNOTATE_VCF {

      publishDir "${params.outdir}", mode: 'copy', pattern: '*.vcf.gz'

    input:
        path variants
        tuple val(rsids_name), path(rsids_vcf), path(rsids_index)

    output:
        path "${params.project}.annotated.vcf.gz", emit: vcf_file

    """
    
    # Annotate vcf with rsID to build nice feature name (-R nedded since there is a bug)
    bcftools annotate ${variants} -a ${rsids_vcf} -c ID -Oz -o ${params.project}.annotated.vcf.gz

    """

}