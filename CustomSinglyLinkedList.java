package com.cts.zip;


public class CustomSinglyLinkedList<D> {

	private int size;
	private Node<D> head;
	private Node<D> tail;
	
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
	
	public void addLast(D data) {
		Node<D> n=new Node<D>(data);
		if(head != null) {
			Node<D> temp=head;
			while(temp.next != null) {
				temp=temp.next;
			}
			temp.next=n;
		}else
			head=n;
		size++;
	}

	public void addFirst(D data) {
		if (head != null) {
			Node<D> temp = head;
			head = new Node<D>(data);
			head.next = temp;
		} else {
			head = new Node<D>(data);
			tail = head;
		}
		size++;
	}

	public void add(D data) {
		if (head != null) {
			Node<D> n = new Node<D>(data);
			Node<D> temp = head;
			while (temp.next != null) {
				temp = temp.next;
			}
			temp.next = n;
			tail = n;
			size++;
		} else {
			addFirst(data);
		}
	}

	public String toString() {
		if (size > 0) {
			System.out.print("[");
			Node temp = head;
			while (temp != null) {
				System.out.print(temp.data);
				if (temp.next != null)
					System.out.print(", ");
				temp = temp.next;
			}
			System.out.print("]");
		} else {
			System.out.println("[]");
		}
		return "";
	}

	public int size() {
		return size;
	}

	private class Node<D> {
		private D data;
		private Node<D> next;

		Node(D data) {
			this.data = data;
			this.next = null;
		}

		@Override
		public String toString() {
			return "Node [data=" + data + ", next=" + next + "]";
		}
	}
	
}
