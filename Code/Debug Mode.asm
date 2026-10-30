
; =============== S U B R O U T I N E =======================================


DebugMode:
		moveq	#0,d0
		move.b	(Debug_placement_routine).w,d0
		move.w	DebugMode_Index(pc,d0.w),d1
		jmp	DebugMode_Index(pc,d1.w)
; End of function DebugMode

; ---------------------------------------------------------------------------
DebugMode_Index:
		dc.w locK_92A20-DebugMode_Index
		dc.w locK_92AB0-DebugMode_Index
; ---------------------------------------------------------------------------
; loc3_5B532:
locK_92A20:
		addq.b	#2,(Debug_placement_routine).w
		move.l	mappings(a0),(Debug_saved_mappings).w
	if ~~Sonic3_Alone
		cmpi.b	#6,routine(a0)
		bhs.s	locK_92A38
	endif
		move.w	art_tile(a0),(Debug_saved_art_tile).w

locK_92A38:
		move.w	(Screen_Y_wrap_value).w,d0
		and.w	d0,(Player_1+y_pos).w
		and.w	d0,(Camera_Y_pos).w
		clr.b	(Scroll_lock).w
		clr.w	(WindTunnel_flag).w
		bclr	#Status_Underwater,status(a0)
		beq.s	locK_92A6E
		movea.l	a0,a1
		jsr	(Player_ResetAirTimer).l
		move.w	#$600,(Max_speed).w
		move.w	#$C,(Acceleration).w
		move.w	#$80,(Deceleration).w
; loc3_5B578:
locK_92A6E:
		move.b	#0,mapping_frame(a0)
		move.b	#0,anim(a0)
		moveq	#0,d0
		move.w	(Current_zone_and_act).w,d0
		ror.b	#1,d0
		lsr.w	#6,d0
		andi.w	#$7E,d0
		lea	(DebugOffs).l,a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		cmp.b	(Debug_object).w,d6
		bhi.s	locK_92AA0
		move.b	#0,(Debug_object).w
; loc3_5B5AA:
locK_92AA0:
		bsr.w	subK_92C88
		move.b	#$C,(Debug_camera_delay).w
		move.b	#1,(Debug_camera_speed).w
; loc3_5B5BA:
locK_92AB0:
		moveq	#0,d0
		move.w	(Current_zone_and_act).w,d0
		ror.b	#1,d0
		lsr.w	#6,d0
		andi.w	#$7E,d0
		lea	(DebugOffs).l,a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d6
		bsr.w	subK_92AD4
		jmp	(Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; sub3_5B5DE:
subK_92AD4:
		moveq	#0,d4
		move.w	#1,d1
		move.b	(Ctrl_1_pressed).w,d4
		andi.w	#button_up_mask|button_down_mask|button_left_mask|button_right_mask,d4
		bne.s	locK_92B16
		move.b	(Ctrl_1_held).w,d0
		andi.w	#button_up_mask|button_down_mask|button_left_mask|button_right_mask,d0
		bne.s	locK_92AFE
		move.b	#$C,(Debug_camera_delay).w
		move.b	#$F,(Debug_camera_speed).w
		bra.w	locK_92B7A
; ---------------------------------------------------------------------------
; loc3_5B608:
locK_92AFE:
		subq.b	#1,(Debug_camera_delay).w
		bne.s	locK_92B1A
		move.b	#1,(Debug_camera_delay).w
		addq.b	#1,(Debug_camera_speed).w
		bne.s	locK_92B16
		move.b	#255,(Debug_camera_speed).w
; loc3_5B620:
locK_92B16:
		move.b	(Ctrl_1_held).w,d4
; loc3_5B624:
locK_92B1A:
		moveq	#0,d1
		move.b	(Debug_camera_speed).w,d1
		addq.w	#1,d1
		swap	d1
		asr.l	#4,d1
		move.l	y_pos(a0),d2
		move.l	x_pos(a0),d3
		btst	#button_up,d4
		beq.s	locK_92B44
		sub.l	d1,d2
		moveq	#0,d0
		move.w	(Camera_min_Y_pos).w,d0
		swap	d0
		cmp.l	d0,d2
		bge.s	locK_92B44
		move.l	d0,d2
; loc3_5B64E:
locK_92B44:
		btst	#button_down,d4
		beq.s	locK_92B5E
		add.l	d1,d2
		moveq	#0,d0
		move.w	(Camera_target_max_Y_pos).w,d0
		addi.w	#$DF,d0
		swap	d0
		cmp.l	d0,d2
		blt.s	locK_92B5E
		move.l	d0,d2
; loc3_5B668:
locK_92B5E:
		btst	#button_left,d4
		beq.s	locK_92B6A
		sub.l	d1,d3
		bcc.s	locK_92B6A
		moveq	#0,d3
; loc3_5B674:
locK_92B6A:
		btst	#button_right,d4
		beq.s	locK_92B72
		add.l	d1,d3
; loc3_5B67C:
locK_92B72:
		move.l	d2,y_pos(a0)
		move.l	d3,x_pos(a0)
; loc3_5B684:
locK_92B7A:
		btst	#button_A,(Ctrl_1_held).w
		beq.s	locK_92BB2
		btst	#button_C,(Ctrl_1_pressed).w
		beq.s	locK_92B96
		subq.b	#1,(Debug_object).w
		bcc.s	locK_92BAE
		add.b	d6,(Debug_object).w
		bra.s	locK_92BAE
; ---------------------------------------------------------------------------
; loc3_5B6A0:
locK_92B96:
		btst	#button_A,(Ctrl_1_pressed).w
		beq.s	locK_92BB2
		addq.b	#1,(Debug_object).w
		cmp.b	(Debug_object).w,d6
		bhi.s	locK_92BAE
		move.b	#0,(Debug_object).w
; loc3_5B6B8:
locK_92BAE:
		bra.w	subK_92C88
; ---------------------------------------------------------------------------
; loc3_5B6BC:
locK_92BB2:
		btst	#button_C,(Ctrl_1_pressed).w
		beq.s	locK_92C0C
		jsr	(AllocateObject).l
		bne.s	locK_92C0C
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	render_flags(a0),status(a1)
		andi.b	#$7F,status(a1)
		moveq	#0,d0
		move.b	(Debug_object).w,d0
		add.w	d0,d0
		move.w	d0,d1
		lsl.w	#2,d0
		add.w	d1,d0
		move.b	4(a2,d0.w),subtype(a1)
		move.l	(a2,d0.w),(a1)
		move.b	#0,(a1)
	if ~~Sonic3_Alone
		cmpi.l	#Obj_Monitor,(a1)
		bne.s	locretK_92C0A
		move.b	#9,subtype(a1)
	endif

locretK_92C0A:
		rts
; ---------------------------------------------------------------------------
; loc3_5B708:
locK_92C0C:
		btst	#button_B,(Ctrl_1_pressed).w
		beq.s	locretK_92C52
		moveq	#0,d0
		move.w	d0,(Debug_placement_mode).w
	if ~~Sonic3_Alone
		move	#$2700,sr
		jsr	(HUD_DrawInitial).l
		move.b	#1,(Update_HUD_score).w
		move.b	#$80,(Update_HUD_ring_count).w
		move	#$2300,sr
	endif
		lea	(Player_1).w,a1
		move.l	(Debug_saved_mappings).w,mappings(a1)
		move.w	(Debug_saved_art_tile).w,art_tile(a1)
		bsr.s	subK_92C54
		move.b	#$13,y_radius(a1)
		move.b	#9,x_radius(a1)
; locret3_5B734:
locretK_92C52:
		rts
; End of function subK_92AD4


; =============== S U B R O U T I N E =======================================

; sub3_5B736:
subK_92C54:
	if FixBugs
		; Clear the entirety of d0, which results in the variables below being cleared.
		moveq	#0,d0
	else
		; Bug: this tries to clear the player's variables using d0, but d0 becomes
		; dirty after the HUD_DrawInitial call, which wasn't there in S3.
		; Miraculously, drawing the lives HUD sets d0 back to zero, but since that
		; part is skipped in Competition mode, exiting debug is broken there.
	endif
		move.b	d0,anim(a1)
		move.w	d0,x_pos+2(a1)
		move.w	d0,y_pos+2(a1)
		move.b	d0,object_control(a1)
		move.b	d0,spin_dash_flag(a1)
		move.w	d0,x_vel(a1)
		move.w	d0,y_vel(a1)
		move.w	d0,ground_vel(a1)
	if Sonic3_Alone
		move.b	#1<<Status_InAir,status(a1)
	else
		andi.b	#1<<Status_Facing,status(a1)
		ori.b	#1<<Status_InAir,status(a1)
	endif
		move.b	#2,routine(a1)
		rts
; End of function subK_92C54


; =============== S U B R O U T I N E =======================================

; sub3_5B764:
subK_92C88:
		moveq	#0,d0
		move.b	(Debug_object).w,d0
		add.w	d0,d0
		move.w	d0,d1
		lsl.w	#2,d0
		add.w	d1,d0
		move.l	4(a2,d0.w),mappings(a0)
		move.w	8(a2,d0.w),art_tile(a0)
		move.b	(a2,d0.w),mapping_frame(a0)
		rts
; End of function subK_92C88

; ---------------------------------------------------------------------------
DebugOffs:		include "Levels/Misc/Debug list pointers.asm"