package com.boardGameMarket.project.domain;

import java.util.Date;

import lombok.Data;

@Data
public class MemberVO {

	private String member_id;
	private String member_password;
	private String member_name;
	private String member_email;
	private String member_phone;
	private int member_role;
	private Date regDate;
	private Date updateDate;
	private MemberAddressVO address;
	
}
