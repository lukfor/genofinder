
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

include { CACHE_JBANG_SCRIPTS } from '../modules/local/cache_jbang_scripts' addParams(outdir: "$outdir")
include { PARSE_QUERIES } from '../modules/local/parse_queries' addParams(outdir: "$outdir")
include { EXTRACT_REGIONS_FROM_VCF } from '../modules/local/extract_regions_from_vcf' addParams(outdir: "$outdir")
include { MERGE_VCF_FILES } from '../modules/local/merge_vcf_files' addParams(outdir: "$outdir")
include { VCF_TO_CSV as VCF_TO_CSV_GT} from '../modules/local/vcf_to_csv' addParams(outdir: "$outdir")
include { VCF_TO_CSV as VCF_TO_CSV_DS} from '../modules/local/vcf_to_csv' addParams(outdir: "$outdir")
include { VCF_TO_CSV_TRANSPOSE as VCF_TO_CSV_TRANSPOSE_GT} from '../modules/local/vcf_to_csv_transpose' addParams(outdir: "$outdir")
include { VCF_TO_CSV_TRANSPOSE as VCF_TO_CSV_TRANSPOSE_DS} from '../modules/local/vcf_to_csv_transpose' addParams(outdir: "$outdir")

workflow EXTRACT_VARIANTS {

    CACHE_JBANG_SCRIPTS (
        file("$baseDir/bin/VcfToCsv.java", checkIfExists: true),
        file("$baseDir/bin/VcfToCsvTranspose.java", checkIfExists: true),
        file("$baseDir/bin/CsvToBed.java", checkIfExists: true)
    )

    PARSE_QUERIES (
        file(params.queries),
        CACHE_JBANG_SCRIPTS.out.csv_to_bed_jar,
    )

    EXTRACT_REGIONS_FROM_VCF (
        PARSE_QUERIES.out.bed_file,
        vcf_files
    )

    MERGE_VCF_FILES (
        EXTRACT_REGIONS_FROM_VCF.out.vcf_file.collect(),
        EXTRACT_REGIONS_FROM_VCF.out.vcf_index_file.collect()
    )

    VCF_TO_CSV_GT (
        MERGE_VCF_FILES.out.vcf_file,
        CACHE_JBANG_SCRIPTS.out.vcf_to_csv_jar,
        "GT"
    )

    VCF_TO_CSV_DS (
        MERGE_VCF_FILES.out.vcf_file,
        CACHE_JBANG_SCRIPTS.out.vcf_to_csv_jar,
        "DS"
    )
    VCF_TO_CSV_TRANSPOSE_GT (
        MERGE_VCF_FILES.out.vcf_file,
        CACHE_JBANG_SCRIPTS.out.vcf_to_csv_transpose_jar,
        "GT"
    )

    VCF_TO_CSV_TRANSPOSE_DS (
        MERGE_VCF_FILES.out.vcf_file,
        CACHE_JBANG_SCRIPTS.out.vcf_to_csv_transpose_jar,
        "DS"
    )

}

workflow.onComplete {
    println "Pipeline completed at: $workflow.complete"
    println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}
