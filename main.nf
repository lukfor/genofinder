#!/usr/bin/env nextflow
/*
========================================================================================
    genepi/gwas-regenie
========================================================================================
    Github : https://github.com/lukfor/extract-variants
    Author: Sebastian Schönherr & Lukas Forer
    ---------------------------
*/

nextflow.enable.dsl = 2

include { EXTRACT_VARIANTS } from './workflows/extract_variants'

/*
========================================================================================
    RUN ALL WORKFLOWS
========================================================================================
*/

workflow {
    EXTRACT_VARIANTS ()
}
