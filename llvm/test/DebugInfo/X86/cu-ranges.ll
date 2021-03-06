; RUN: llc -split-dwarf=Enable -O0 %s -function-sections -mtriple=x86_64-unknown-linux-gnu -filetype=obj -o %t
; RUN: llvm-dwarfdump -debug-dump=abbrev %t | FileCheck --check-prefix=FUNCTION-SECTIONS %s
; RUN: llvm-readobj --relocations %t | FileCheck --check-prefix=FUNCTION-SECTIONS-RELOCS %s

; RUN: llc -split-dwarf=Enable -O0 %s -mtriple=x86_64-unknown-linux-gnu -filetype=obj -o %t
; RUN: llvm-dwarfdump -debug-dump=abbrev %t | FileCheck --check-prefix=NO-FUNCTION-SECTIONS %s

; From:
; int foo (int a) {
;   return a+1;
; }
; int bar (int b) {
;   return b+2;
; }

; With function sections enabled make sure that we have a DW_AT_ranges attribute.
; FUNCTION-SECTIONS: DW_AT_ranges

; Check that we have a relocation against the .debug_ranges section.
; FUNCTION-SECTIONS-RELOCS: R_X86_64_32 .debug_ranges 0x0

; Without function sections enabled make sure that we have no DW_AT_ranges attribute.
; NO-FUNCTION-SECTIONS-NOT: DW_AT_ranges
; NO-FUNCTION-SECTIONS: DW_AT_low_pc DW_FORM_addr
; NO-FUNCTION-SECTIONS-NOT: DW_AT_ranges

; Function Attrs: nounwind uwtable
define i32 @foo(i32 %a) #0 {
entry:
  %a.addr = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %a.addr}, metadata !13, metadata !{metadata !"0x102"}), !dbg !14
  %0 = load i32* %a.addr, align 4, !dbg !14
  %add = add nsw i32 %0, 1, !dbg !14
  ret i32 %add, !dbg !14
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind uwtable
define i32 @bar(i32 %b) #0 {
entry:
  %b.addr = alloca i32, align 4
  store i32 %b, i32* %b.addr, align 4
  call void @llvm.dbg.declare(metadata !{i32* %b.addr}, metadata !15, metadata !{metadata !"0x102"}), !dbg !16
  %0 = load i32* %b.addr, align 4, !dbg !16
  %add = add nsw i32 %0, 2, !dbg !16
  ret i32 %add, !dbg !16
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!10, !11}
!llvm.ident = !{!12}

!0 = metadata !{metadata !"0x11\0012\00clang version 3.5.0 (trunk 204164) (llvm/trunk 204183)\000\00\000\00\001", metadata !1, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2} ; [ DW_TAG_compile_unit ] [/usr/local/google/home/echristo/z.c] [DW_LANG_C99]
!1 = metadata !{metadata !"z.c", metadata !"/usr/local/google/home/echristo"}
!2 = metadata !{}
!3 = metadata !{metadata !4, metadata !9}
!4 = metadata !{metadata !"0x2e\00foo\00foo\00\001\000\001\000\006\00256\000\001", metadata !1, metadata !5, metadata !6, null, i32 (i32)* @foo, null, null, metadata !2} ; [ DW_TAG_subprogram ] [line 1] [def] [foo]
!5 = metadata !{metadata !"0x29", metadata !1}          ; [ DW_TAG_file_type ] [/usr/local/google/home/echristo/z.c]
!6 = metadata !{metadata !"0x15\00\000\000\000\000\000\000", i32 0, null, null, metadata !7, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8, metadata !8}
!8 = metadata !{metadata !"0x24\00int\000\0032\0032\000\000\005", null, null} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!9 = metadata !{metadata !"0x2e\00bar\00bar\00\002\000\001\000\006\00256\000\002", metadata !1, metadata !5, metadata !6, null, i32 (i32)* @bar, null, null, metadata !2} ; [ DW_TAG_subprogram ] [line 2] [def] [bar]
!10 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!11 = metadata !{i32 1, metadata !"Debug Info Version", i32 2}
!12 = metadata !{metadata !"clang version 3.5.0 (trunk 204164) (llvm/trunk 204183)"}
!13 = metadata !{metadata !"0x101\00a\0016777217\000", metadata !4, metadata !5, metadata !8} ; [ DW_TAG_arg_variable ] [a] [line 1]
!14 = metadata !{i32 1, i32 0, metadata !4, null}
!15 = metadata !{metadata !"0x101\00b\0016777218\000", metadata !9, metadata !5, metadata !8} ; [ DW_TAG_arg_variable ] [b] [line 2]
!16 = metadata !{i32 2, i32 0, metadata !9, null}
