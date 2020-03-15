package com.cts.zip;

import java.util.Deque;

/**
 * The <code>Stack</code> class represents a last-in-first-out
 * the stack for an item and discover how far it is from the top.
 * <p>
 * When a stack is first created, it contains no items. Array size is ten.
 * 
 * @author  Mithilesh
 * @since   2020
 */
public class CustomStackArrayStatic<T> {

	final int fixedSize=10;
	int index,size;
	Object[] objArray;
	/**
     * Creates an empty Stack.
     */
	public CustomStackArrayStatic() {
		objArray=new Object[fixedSize];
		System.out.println("object created successfully");
	}//constructor

	public boolean push(T o) {
		if (size != fixedSize) {
			objArray[index] = o;
			index++;
			size++;
			return true;
		} else
			throw new IllegalArgumentException("Stack is full");
	}

	public T pop() {
		T obj;
		if(index!=0) {
			obj=(T) objArray[index-1];
			index--;
			size--;
			return obj;
		}else
			throw new IllegalArgumentException("No element found"); 
	}

	public T peek() {
		if(index!=0)
			return (T) objArray[index-1];
		else
			throw new IllegalArgumentException("No element found");
	}

	public boolean isEmpty() {
		return index == 0;
	}//isEmpty
	
	public int size() {
		return size;
	}//size
	
	public int searchAt(T t) {
		for(int i=0;i<size;i++) {
			if(t.equals(objArray[i])) {
				return i;
			}
		}
		return -1;
	}
	
	@Override
	public String toString() {
		System.out.print("[");
		for(int i=0;i<size;i++) {
			System.out.print(objArray[i]);
			if(i+1<size)
				System.out.print(",");
		}
		System.out.print("]");
		return "";
	}
}