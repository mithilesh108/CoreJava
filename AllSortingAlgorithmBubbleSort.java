package com.cts.singleton;

import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class AllSortingAlgorithmBubbleSort {

	public final static void main(String[] args) {
		System.out.println("start");
		List list=new LinkedList<>();
		list.add("ert");list.add("ert");list.add("ert");list.add("ert");list.add("ert");
		System.out.println(list.get(0));
		System.out.println(list);
		System.out.println("end");
//		int[] array = { 8, 16, 23, 31, 47 };
//		System.out.println("Before sort : " + Arrays.toString(array));
//		System.out.println(binarySearchIterative(array,0,array.length,47));
		//System.out.println(binarySearchRecursive(array,0,array.length-1,8));
		// System.out.println("After Bubble sort :
		// "+Arrays.toString(bubboleSort(array,array.length)));
		// System.out.prRemovedintln("After Insertion sort :
		// "+Arrays.toString(insertionSort(array,array.length)));
		// System.out.println("After Insertion sort :
		// "+Arrays.toString(selectionSort(array,array.length)));
		//System.out.println("After  element : " + Arrays.toString(selectionSort(array, array.length)));
	}// main
	
	private static int binarySearchRecursive(int[] arr, int left,int right,int val) {
		int mid;
		if(right>=left) {
			System.out.println("if");
			mid=(right+left)/2;
			if(val==arr[mid])
				return arr[mid];
			else if(val>arr[mid]) {
				System.out.println("else if");
				return binarySearchRecursive(arr, mid+1,right, val);
			}
			else {
				System.out.println("else");
			    //return binarySearchRecursive(arr, mid+1,right, val);
			    return binarySearchRecursive(arr,left,mid-1,val);
			}
		}
		return -1;
	}

	private static int binarySearchIterative(int[] arr, int left,int right,int val) {
		int mid;
		while(right>=left) {
			System.out.println("while");
			mid=(right+left)/2;
			if(arr[mid]==val)
				return arr[mid];
			else if(val>arr[mid])
				left=mid+1;
			else
				right=mid-1;
			
		}//while
		return -1;
	}
	
	private static int[] remove(int[] arr, int index) {
		int[] updateArray = null;
		if (index < arr.length) {
			updateArray = new int[arr.length - 1];
			for (int i = 0; i < arr.length - 1; i++) {
				if (i >= index) {
					arr[i] = arr[i + 1];
					updateArray[i] = arr[i];
				} else
					updateArray[i] = arr[i];
			}
		} else
			throw new ArrayIndexOutOfBoundsException();

		return updateArray;
	}

	private static int[] insertionSortMinSwap(int[] array, int len) {
		int temp = 0, j = 0;
		for (int i = 1; i < len; i++) {
			System.out.println("outer " + i);
			temp = array[i];
			for (j = i - 1; j >= 0 && temp < array[j];) {
				System.out.println("inner " + j);
				array[j + 1] = array[j];
				j--;
			}
			array[j + 1] = temp;
		}
		return array;
	}// insertionSort(-,-)

	private static int[] insertionSortMaxSwap(int[] a, int len) {
		int temp, j;
		boolean flag = false;
		for (int i = 1; i < len; i++) {
			System.out.println("outer " + i);
			temp = a[i];
			for (j = i - 1; j >= 0; j--) {
				flag = false;
				System.out.println("inner ------- " + j);
				if (a[j] > temp) {
					a[j + 1] = a[j];
					a[j] = temp;
					flag = true;
				}
				if (!flag)
					break;
			}
			System.out.println("Before sort : " + Arrays.toString(a));
		}
		return a;
	}

	private static String duplicateElements(int[] a, int len) {
		Map m = new HashMap();
		for (int i = 0; i < len; i++) {
			if (m.containsKey(a[i]))
				m.put(a[i], m.get(a[i]));
			else
				m.put(a[i], 1);
		} // for
		System.out.println(m);
		String d = (String) m.get("1");
		return null;
	}

	private static int secondHigestElement(int[] a,int len) {
		if(!(a.length>1))
		   System.out.println("please pass array with two elements");
		int first = 0,second=0;
		for(int i=0;i<len;i++) {
		     if(a[i]>first) {
		    	 second=first;
		    	 first=a[i];
		     }else if(a[i]>second && first!=a[i])
		    	 second=a[i];
		}
		if(second==0)
			System.out.println("No second higest elements, All elements are same");
		else
		    System.out.println("second "+second);
		return 0;
	} 
	
	private static int[] selectionSort(int[] a, int len) {
		int min, temp;
		for (int i = 0; i < len - 1; i++) {
			System.out.println("OUTER : " + i);
			min = i;
			for (int j = i + 1; j < len; j++) {
				System.out.println("inner -----: " + j);
				if (a[min] > a[j]) {
					min = j;
				}
			}
			System.out.println("min : " + min);
			if (min != i) {
//				  temp=a[i]; 
//				  a[i]=a[min]; 
//				  a[min]=temp;
				 
				a[i] = a[i] + a[min];
				a[min] = a[i] - a[min];
				a[i] = a[i] - a[min];
			}
			System.out.println("Before sort : " + Arrays.toString(a));
		}
		return a;
	}

	private static int[] bubboleSort(int[] a, int len) {
		int temp;
		boolean flag = false;
		for (int i = 0; i < len - 1; i++) {
			System.out.println("OUTER for " + i);
			flag = false;
			for (int j = 0; j < len - 1 - i; j++) {
				System.out.println("inner for---- " + j);
				if (a[j] > a[j + 1]) {
					temp = a[j];
					a[j] = a[j + 1];
					a[j + 1] = temp;
					flag = true;
				}
			}
			if (!flag)
				break;
		}
		return a;
	}

}// class