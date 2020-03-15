package com.cts.datastructure;

import java.util.Arrays;

public class AllSortaingAlgorithm {

	public static void main(String[] args) {
		System.out.println("main method start");
		int[] no= {8,9,11,4,1};
		//bubboleSort(no);
		selectionSort(no);
		System.out.println("main method start");
	}
	
	private static void selectionSort(int[] no) {
		System.out.println(Arrays.toString(no));
		int temp =0,len=no.length,n;
		for(int i=0; i<len; i++) {
			for(int j=1; j<len; j++) {
				if(no[i] > no[j])
					temp=j;
			}
			n=no[i];
			no[i]=no[temp];
			no[temp]=n;
			
		}
		System.out.println(Arrays.toString(no));
	}

	private static void bubboleSort(int[] no) {
		System.out.println(Arrays.toString(no));
		int temp =0,flag=0,len=no.length;;
		for(int i = 0; i < len-1; i++) {
			System.out.println("i : "+i);
			flag=0;
			for(int j = 0; j < len-1-i; j++) {
				System.out.println(Arrays.toString(no)+" j : "+j);
				if(no[j] > no[j+1]) {
					temp = no[j];
					no[j] = no[j+1];
					no[j+1] = temp;
					flag=1;
				}
			}
			//if array are already sorted 
			if(flag == 0)
				break;
		}
		System.out.println(Arrays.toString(no));
	}//bubboleSort(-)
}
