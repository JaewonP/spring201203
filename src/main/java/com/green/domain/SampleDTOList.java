package com.green.domain;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class SampleDTOList {
	private List<SampleDTO> list; //타입추론이 가능
	
	public SampleDTOList() {
		list = new ArrayList<SampleDTO>();
	}

}
