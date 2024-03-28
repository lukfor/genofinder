process ANNOTATE_VCF {

      publishDir "${params.outdir}", mode: 'copy', pattern: '*.vcf.gz'

    input:
        path variants
        tuple val(rsids_name), path(rsids_vcf), path(rsids_index)

    output:
        path "${params.project}.annotated.vcf.gz", emit: vcf_file

    """
    
    # Annotate vcf with rsID to build nice column names
    bcftools index ${variants}
    # With a region in annotate it is much faster! found: https://github.com/samtools/bcftools/issues/1199#issuecomment-624713745
    bcftools query -f '%CHROM\t%POS\n' ${variants} > sites.txt
    bcftools annotate -R sites.txt ${variants} -a ${rsids_vcf} -c ID -Oz -o ${params.project}.annotated.vcf.gz

    """

}
