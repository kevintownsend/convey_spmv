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
	mov.AE0 %aeg, $0, %a8
    rtn

cpInstructionAE1:
    .globl  cpInstructionAE1
    .type   cpInstructionAE1. @function
    .signature pdk=65042
	mov.AE1 %a8, $0, %aeg		# a8 contains address of a1
	caep01.AE1 $0
	mov.AE1 %aeg, $0, %a8
    rtn

cpInstructionAE2:
    .globl  cpInstructionAE2
    .type   cpInstructionAE2. @function
    .signature pdk=65042
	mov.AE2 %a8, $0, %aeg		# a8 contains address of a1
	caep01.AE2 $0
	mov.AE2 %aeg, $0, %a8
    rtn

cpInstructionAE3:
    .globl  cpInstructionAE3
    .type   cpInstructionAE3. @function
    .signature pdk=65042
	mov.AE3 %a8, $0, %aeg		# a8 contains address of a1
	caep01.AE3 $0
	mov.AE3 %aeg, $0, %a8
    rtn

cpInstructionAEall:
    .globl  cpInstructionAEall
    .type   cpInstructionAEall. @function
    .signature pdk=65042
	mov %a8, $0, %aeg		# a8 contains address of a1
	caep01 $0
	mov.AE0 %aeg, $0, %a8
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
