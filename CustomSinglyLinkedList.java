package com.cts.zip;


public class CustomSinglyLinkedList<D> {

	private int size;
	private Node head;
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
	
	public void addAt(int index,D data) {
		if(index>size)
			throw new ArrayIndexOutOfBoundsException("index : "+index+", size : "+size);
		else if(index == 0) 
			addFirst(data);
		else if(index == size) 
			addLast(data);
		else {
			Node<D> n=new Node<D>(data);
			Node<D> temp=head;
			for(int i=0;i<index-1;i++){
				temp=temp.next;
			}
			Node<D> leftNode=temp.next;
			temp.next=n;
			n.next=leftNode;
			size++;
		}
	}
	---------------------------------------------------------------------------------------------
	
	public void addFirst(T data) {
		System.out.println("addFirst");
		if (head == null)
			head = new Node(data);
		else {
			Node newNode = new Node(data);
			newNode.next = head;
			head = newNode;
		}
		size++;
	}

	public void addLast(T data) {
		System.out.println("addlast");
		if (head != null) {
			Node newNode = new Node(data);
			Node temp = head;
			while (temp.next != null)
				temp = temp.next;
			temp.next = newNode;
		} else
			head = new Node(data);
		size++;
	}

	public void add(T data) {
		if (head != null) {
			addLast(data);
		} else
			addFirst(data);
		size++;
	}

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
		private Node next;

		public Node(T data) {
			this.data = data;
		}
	}
}
