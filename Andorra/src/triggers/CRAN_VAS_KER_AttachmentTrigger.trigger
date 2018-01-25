trigger CRAN_VAS_KER_AttachmentTrigger on Attachment (after insert) {
    new CRAN_VAS_KER_AttachmentTriggerHndlr_CLS(Attachment.getSObjectType()).run(); 
}