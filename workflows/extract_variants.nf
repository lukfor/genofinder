
requiredParams = [
    'project', 'genotypes_imputed', 'genotypes_build',
    'genotypes_imputed_format', 'queries'
]

for (param in requiredParams) {
    if (params[param] == null) {
      exit 1, "Parameter ${param} is required."
    }
}

if(params.outdir == null) {
  outdir = "output/${params.project}"
} else {
  outdir = params.outdir
}

//Check imputed file format
if (params.genotypes_imputed_format != 'vcf'){
  exit 1, "File format ${params.genotypes_imputed_format} not supported."
}

Channel.fromFilePairs(params.genotypes_imputed, size: 2).set {vcf_files}

include { PARSE_QUERIES } from '../modules/local/parse_queries'
include { EXTRACT_REGIONS_FROM_VCF } from '../modules/local/extract_regions_from_vcf'
include { MERGE_VCF_FILES } from '../modules/local/merge_vcf_files'
include { ANNOTATE_VCF} from '../modules/local/annotate_vcf.nf'
include { VCF_TO_CSV as VCF_TO_CSV_GT} from '../modules/local/vcf_to_csv'
include { VCF_TO_CSV as VCF_TO_CSV_DS} from '../modules/local/vcf_to_csv'
include { VCF_TO_CSV_TRANSPOSE as VCF_TO_CSV_TRANSPOSE_GT} from '../modules/local/vcf_to_csv_transpose'
include { VCF_TO_CSV_TRANSPOSE as VCF_TO_CSV_TRANSPOSE_DS} from '../modules/local/vcf_to_csv_transpose'

workflow EXTRACT_VARIANTS {

    rsids = tuple(null, null, null)
    if (params.rsids  != null) {
        rsids =  Channel.fromFilePairs(params.rsids, size: 2, flat: true)
    }
            
    PARSE_QUERIES (
        file(params.queries),
        rsids
    )

    EXTRACT_REGIONS_FROM_VCF (
        PARSE_QUERIES.out.bed_file,
        vcf_files
    )

    MERGE_VCF_FILES (
        EXTRACT_REGIONS_FROM_VCF.out.vcf_file.collect(),
        EXTRACT_REGIONS_FROM_VCF.out.vcf_index_file.collect()
    )

    if (params.annotation != null) {
        annotation =  Channel.fromFilePairs(params.annotation, size: 2, flat: true)
        ANNOTATE_VCF (
            MERGE_VCF_FILES.out.vcf_file,
            annotation
        )
        vcf_file = ANNOTATE_VCF.out.vcf_file
    } else {
        vcf_file = MERGE_VCF_FILES.out.vcf_file
    }

    // convert vcf file into different csv files
    VCF_TO_CSV_GT (vcf_file, "GT")
    VCF_TO_CSV_DS (vcf_file, "DS")
    VCF_TO_CSV_TRANSPOSE_GT (vcf_file, "GT")
    VCF_TO_CSV_TRANSPOSE_DS (vcf_file, "DS")

}

workflow.onComplete {
    println "Pipeline completed at: $workflow.complete"
    println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}
