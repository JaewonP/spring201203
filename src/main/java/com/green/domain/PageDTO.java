package com.green.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
	private int startPage;
	private int endPage;
	private boolean prev, next;
	
	private int total;
	private Criteria cri;
	
	public PageDTO(Criteria cri, int total) {
		this.cri = cri;
		this.total = total;
		
		this.endPage = (int) (Math.ceil(cri.getPageNum()/10.0)) * 10;
		this.startPage = this.endPage-9;
		
		//305pg
		//���� ����ȣ(endPage) �� ���������� ��µǴ� �������� �� (amount)�� ����
		//��ü ������ ��(total)���� ũ�ٸ� ����ȣ(endPage)�� �ٽ� total�� 
		//�̿��Ͽ� �ٽ� ���Ǿ�� �� 
		//���� ��ü ������ ��(total) �� �̿��Ͽ� ��¥ ��������(realEnd)�� 
		//�� ������ �Ǵ����� �����, ���� ��¥ ��������(realEnd)�� ���ص�
		//����ȣ(endPage)���� �۴ٸ� ����ȣ�� ���� ���� �Ǿ���� 
		//����ȣ ������ Math.ceil(�Ҽ����� �ø����� ó��)�� �̿��Ͽ� ���� 
		//1�������� ��� Math.ceil(0.1)*10 = 10
		//10�������� ��� Math.ceil(1)*10=10
		//11�������� ��� Math.ceil(1.1)*10=20
		//���� ȭ�鿡 10���� �����شٸ� ���� ��ȣ(startPage)�� ������ �� ��ȣ(endPage)
		//���� 9��� ���� �� ���� �� 
		
		int realEnd = (int) (Math.ceil((total*1.0)/cri.getAmount()));
		if(realEnd<this.endPage) {
			this.endPage = realEnd;
		}
		this.prev = this.startPage >1;
		this.next = this.endPage < realEnd;
		
	}
}
