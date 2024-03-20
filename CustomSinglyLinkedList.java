package com.cts;

public class SingleLinkedList<T> {

	private int size;
	private Node head;

	public int size() {
		return size;
	}//size()
	---------------------------------------------------------------------------------
	public void removeAt(int index) {
		if(index < size) {
			Node<D> n=head;
			for(int i=1;i<index-1;i++)
				n=n.next;
			Node<D> nextNode=n.next.next;
			n.next=nextNode;
			size--;
		}else if(index == 0)
			throw new IllegalArgumentException("List is empty");
	}
	
	public void removeFirst() {
		if(size != 0) {
			Node<D> temp=head;
			head=temp.next;
			size--;
		}
		else 
			throw new IllegalArgumentException("There is no element found in list");
	}
	
	public void removeLast() {
		if(size != 0) {
			Node<D> temp=head;
			for(int i=1;i<size-1;i++) {
				System.out.println("www");
				temp=temp.next;
			}
			temp.next=null;
			 // Find the second last node 
	      /*  Node second_last = head; 
	        while (second_last.next.next != null) 
	            second_last = second_last.next; 
	            System.out.println("www");
	  
	        // Change next of second last 
	        second_last.next = null; */
			size--;
		}
		else 
			throw new IllegalArgumentException("There is no element found in list");
	}
	

	public void addAt(int index, T data) {
		if (index > size || index < 0)
			throw new IndexOutOfBoundsException("Index " + index + " Size " + size);
		else if (index == 0)
			addFirst(data);
		else if (index == size)
			addLast(data);
		else {
			Node newNode = new Node(data);
			Node temp = head;
			for (int i = 1; i < index; i++) {
				temp = temp.next;
			}// for
			newNode.next = temp.next;
			temp.next = newNode;
			size++;
		}//else
	}//addAt(-,-)

	public void addFirst(T data) {
		Node newNode = new Node(data);
		if (head == null)
			head =newNode;
		else {
			newNode.next = head;
			head = newNode;
		}
		size++;
	}//addFirst(-)

	public void addLast(T data) {
		Node newNode = new Node(data);
		if (head == null) {
			head = newNode;
			
		} else {
			Node temp = head;
			while (temp.next != null)
				temp = temp.next;
			temp.next = newNode;
		}
		size++;
	}//addLast(-)

	public void add(T data) {
		if (head == null) 
			addFirst(data);
		else
			addLast(data);
	}//add(-)

	@Override
	public String toString() {
		if (size == 0)
			return "List is empty";
		Node temp = head;
		while (temp != null) {
			System.out.print(temp.data + " ");
			temp = temp.next;
		}
		return "";
	}

	class Node<T> {
		private T data;
		private Node<T> next;

		public Node(T data) {
			this.data = data;
		}
	}
}
