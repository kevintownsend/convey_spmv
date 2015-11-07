#TODO: add header information
	.file	"cpCnySpmv.s"
	.ctext

#TODO: remove sample function
# sample fuction
cpTalk:
    .globl  cpTalk
    .type   cpTalk. @function
    .signature pdk=65042
    caep00 $0
    rtn

cpInstructionAE0:
    .globl  cpInstructionAE0
    .type   cpInstructionAE0. @function
    .signature pdk=65042
	mov.AE0 %a8, $0, %aeg		# a8 contains address of a1
	caep01.AE0 $0
    rtn

#TODO: add function
#TODO: name function
#   .globl functionName
#   .type functionName. @function
#   .signature pdk=65042
#TODO: pass arguments using mov
#TODO: call custom instruction
#TODO: return value using mov
#   rtn
