package com.green.domain;

import java.util.Date;

import lombok.Data;

@Data
public class ReplyVO {
 	private Long rno ; //��� ��ȣ
 	private Long  bno ; //�Խñ� ��ȣ (foreign key)
    private String reply ; //��۳���
    private String replyer ; //��� �ۼ���
    private Date replyDate ; //����ۼ���
    private Date updateDate ; //��� ������ 
}
