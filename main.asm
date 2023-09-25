option casemap:none
ExitProcess proto
WriteConsoleA proto
GetStdHandle proto
ReadConsoleA proto
Sleep proto
.data

bytes_written qword ?
A QWORD 067452301H
B QWORD 0efcdab89H
C QWORD 098badcfeH
D QWORD 010325476H
A2 QWORD 067452301H
B2 QWORD 0efcdab89H
C2 QWORD 098badcfeH
D2 QWORD 010325476H
A3 QWORD 067452301H
B3 QWORD 0efcdab89H
C3 QWORD 098badcfeH
D3 QWORD 010325476H
F QWORD ?
G QWORD ?
user DB 64 dup(0)
user2 DB 129 dup(0)
string DB 1000 dup(0)
user_options DB 3 dup(0)
menu_string DB 10,"MD5 ENCRIPTION",10,"1 = Encrypt",10,"other = Exit",10,0
good_bay DB "GOOD BAY",10,0
enter_string_encrypt DB "Enter string to encrypt hash md5: ",0
string_encrypted DB "Encrypted: ",0
K DD 0d76aa478H, 0e8c7b756H, 242070dbH, 0c1bdceeeH,0f57c0fafH, 4787c62aH, 0a8304613H, 0fd469501H
  DD 698098d8H, 8b44f7afH, 0ffff5bb1H, 895cd7beH,06b901122H, 0fd987193H, 0a679438eH, 49b40821H
  DD 0f61e2562H, 0c040b340H, 265e5a51H, 0e9b6c7aaH,0d62f105dH, 02441453H, 0d8a1e681H, 0e7d3fbc8H
  DD 021e1cde6H, 0c33707d6H, 0f4d50d87H, 0455a14edH,0a9e3e905H, 0fcefa3f8H, 0676f02d9H, 08d2a4c8aH
  DD 0fffa3942H, 08771f681H, 06d9d6122H, 0fde5380cH,0a4beea44H, 04bdecfa9H, 0f6bb4b60H, 0bebfbc70H
  DD 0289b7ec6H, 0eaa127faH, 0d4ef3085H, 004881d05H,0d9d4d039H, 0e6db99e5H, 01fa27cf8H, 0c4ac5665H
  DD 0f4292244H, 0432aff97H, 0ab9423a7H, 0fc93a039H,0655b59c3H, 08f0ccc92H, 0ffeff47dH, 085845dd1H
  DD 06fa87e4fH, 0fe2ce6e0H, 0a3014314H, 04e0811a1H,0f7537e82H, 0bd3af235H, 02ad7d2bbH, 0eb86d391H
S DB 7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22
  DB 5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20
  DB 4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23
  DB 6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21
.code
	main proc
		call menu
		mov rcx,10000
		call Sleep
		mov rcx,0
		call ExitProcess
	main endp

	input_string proc
		push rbp
		mov rbp,rsp
		mov rcx,-10
		call GetStdHandle
		mov rcx,rax
		mov rdx,[rbp+16]
		mov r8,[rbp+24]
		lea r9,bytes_written
		push 0h
		call ReadConsoleA
		pop rcx
		pop rbp
		pop rdx
		pop rcx
		pop rcx
		push rdx
		ret
	input_string endp

	print_string proc
		push rbp
		mov rbp,rsp
		mov rcx,-11
		call GetStdHandle
		mov rcx,rax
		mov rdx,[rbp+16]
		mov r8,[rbp+24]
		lea r9,bytes_written
		push 0h
		call WriteConsoleA
		pop rcx
		pop rbp
		pop rdx
		pop rcx
		pop rcx
		push rdx
		ret
	print_string endp

	clear_string proc
		run3:
			mov byte ptr[rsi],0
			inc rsi
			cmp byte ptr[rsi],0
			jne run3
		ret
	clear_string endp

	remove_enter_char proc
		run4:
			inc rsi
			cmp byte ptr[rsi],10
		jne run4
		mov byte ptr[rsi],0
		dec rsi
		mov byte ptr[rsi],0
		ret
	remove_enter_char endp

	menu proc
		run_menu:
		mov rsi,offset menu_string
		push 41
		push rsi
		call print_string
		mov rsi,offset user_options
		push 3
		push rsi
		call input_string
		mov rsi,offset user_options
		cmp byte ptr[rsi],'1'
		je menu_enc
		mov rsi,offset good_bay
		push 10
		push rsi
		call print_string
		ret
		menu_enc:
		call encrypt_menu
		mov rsi,offset user2
		call clear_string
		mov rsi,offset user
		call clear_string
		jmp run_menu
	menu endp

	encrypt_menu proc
		mov rsi,offset enter_string_encrypt
		push 35
		push rsi
		call print_string
		mov rsi,offset user
		push 56
		push rsi
		call input_string
		call encrypt
		call to_printable_hex
		mov rsi,offset user2
		push 32
		push rsi
		call print_string
		ret
	encrypt_menu endp
	
	encrypt proc
		mov rsi,offset user
		call remove_enter_char
		mov byte ptr[rsi],1
		mov r12,A
		mov A3,r12
		mov r12,B
		mov B3,r12
		mov r12,C
		mov C3,r12
		mov r12,D
		mov D3,r12

		mov r13,0
		run_encrypt2:
			mov r12,A
			mov A2,r12
			mov r12,B
			mov B2,r12
			mov r12,C
			mov C2,r12
			mov r12,D
			mov D2,r12
			mov r12,0
			run_encrypt:
				cmp r12,47
				jg enc_4
				cmp r12,31
				jg enc_3
				cmp r12,15
				jg enc_2
				mov r14,B2
				and r14,C2
				mov r15,B2
				not r15
				and r15,D2
				or r14,r15
				mov rdx,r12
				jmp run_encrypt_end1
				enc_2:
				mov r14,D2
				and r14,B2
				mov r15,D2
				not r15
				and r15,C2
				or r14,r15
				mov rax,r12
				mov rbx,5
				mov rdx,0
				mul rbx
				inc rax
				mov rdx,0
				mov rbx,16
				div rbx
				jmp run_encrypt_end1
				enc_3:
				mov r14,B2
				xor r14,C2
				xor r14,D2
				mov rax,r12
				mov rbx,3
				mov rdx,0
				mul rbx
				add rax,5
				mov rdx,0
				mov rbx,16
				div rbx
				jmp run_encrypt_end1
				enc_4:
				mov r14,C2
				mov r15,D2
				not r15
				or r15,B
				xor r14,r15
				mov rbx,7
				mov rdx,0
				mul rbx
				mov rdx,0
				mov rbx,16
				div rbx
				run_encrypt_end1:
				mov G,rdx
				mov F,r14
				mov rsi,offset K
				mov r14,A2
				add F,r14
				mov rax,r12
				mov rdx,0
				mov rbx,4
				mul rbx
				mov rbx,rax
				mov edx,[rsi+rbx]
				add F,rdx
				mov rsi,offset user
				mov rdx,0
				mov rax,0
				mov rax,G
				mov rbx,4
				mul rbx
				add rsi,rax
				mov rbx,[rsi]
				add F,rbx
				mov r14,D2
				mov A2,r14
				mov r14,C2
				mov D2,r14
				mov r14,B2
				mov C2,r14
				mov r14,F
				mov rsi,offset S
				add rsi,r12
				mov cl,[rsi]
				shl r14,cl
				add B2,r14
				inc r12
				cmp r12,64
				jl run_encrypt
			mov r12,A2
			add A3,r12
			mov r12,B2
			add B3,r12
			mov r12,C2
			add C3,r12
			mov r12,D2
			add D3,r12
			inc r13
			cmp r13,512
			jl run_encrypt2
		mov rsi,offset user
		mov rax,A3
		mov cl,24
		ror eax,cl
		mov [rsi],eax
		mov rax,B3
		mov cl,24
		ror eax,cl
		mov [rsi+4],eax
		mov rax,C3
		mov cl,24
		ror eax,cl
		mov [rsi+8],eax
		mov rax,D3
		mov cl,24
		ror eax,cl
		mov [rsi+12],eax
		ret
	encrypt endp

	to_printable_hex proc
		mov rsi,offset user
		mov rdi,offset user2
		mov rbx,0
		run_split:
		mov r11b,[rsi]
		and r11b,0fh
		mov [rdi],r11b
		mov r11b,[rsi]
		shr r11b,4
		mov [rdi+1],r11b
		add rdi,2
		inc rsi
		inc rbx
		cmp rbx,16
		jl run_split
		dec rdi
		mov byte ptr[rdi],0
		call convert_to_printable
		ret
	to_printable_hex endp

	convert_to_printable proc
		mov rsi,offset user2
		mov rbx,32
		run_convert:
		cmp byte ptr[rsi],9
		jg letter
		add byte ptr[rsi],48
		jmp next_convert
		letter:
		add byte ptr[rsi],55
		next_convert:
		inc rsi
		dec rbx
		jnz run_convert
		mov byte ptr[rsi],0
		ret
	convert_to_printable endp

end