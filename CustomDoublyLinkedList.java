package com.cts.singleton;

public class CustomDoublyLinkedList<D> {

	private Node<D> head;
	private Node<D> tail;
	private int size;

	public void reverse() {
		if (size == 0)
			throw new IllegalArgumentException("List is empty");
		else if(size > 1){
			System.out.print("[");
			Node<D> temp = tail;
			while (temp != null) {
				System.out.print(temp.data);
				if (temp.prev != null)
					System.out.print(", ");
				temp = temp.prev;
			}
			System.out.println("]");
		}
	} 
	
	public void removeFirst() {
		if (size == 0)
			throw new IllegalArgumentException("List is empty");
		else if (size == 1)
			head = tail = null;
		else {
			head = head.next;
			head.prev = null;
		}
		size--;
	}

	public void removeLast() {
		if (size == 0)
			throw new IllegalArgumentException("List is empty");
		else if (size == 1)
			head = tail = null;
		else {
			tail = tail.prev;
			tail.next = null;
		}
		size--;
	}

	public void removeAt(int index) {
		if (index < 0 || index == 0)
			throw new IllegalArgumentException("Please pass +ive number : "+index);
		else if ( size == 0)
			throw new IllegalArgumentException("List is empty");
		else if (index > size)
			throw new ArrayIndexOutOfBoundsException("Index : " + index + ", Size : " + size);
		else if (index == 1)
			removeFirst();
		else if (size == index)
			removeLast();
		else{
			Node<D> temp=head;
			for(int i=1;i<index-1;i++) {
				temp=temp.next;
			}
			Node<D> leftNode=temp.next.next;
			temp.next.prev=temp;
			temp.next=leftNode;
			size--;
		}
	}

	public void addAt(int index, D data) {
		if (index == 0)
			addFirst(data);
		else if (index == size)
			addLast(data);
		else if (index > size)
			throw new ArrayIndexOutOfBoundsException("Index : " + index + ", Size : " + size);
		else if (index < 0)
			throw new IllegalArgumentException("Dont pass -ve as index");
		else {
			Node<D> newNode = new Node<D>(data);
			Node<D> temp = head;
			for (int i = 1; i < index - 1; i++) {
				temp = temp.next;
			}
			newNode.prev = temp;
			newNode.next = temp.next;
			temp.next.prev = newNode;
			temp.next = newNode;
			size++;
		}
	}

	public void addLast(D data) {
		Node<D> newNode = new Node<D>(data);
		if (head == null)
			head = tail = newNode;
		 else {
			newNode.prev = tail;
			tail.next = newNode;
			tail = newNode;
		}
		size++;
	}

	
	public void addFirst(D data) {
		Node<D> newNode = new Node<D>(data);
		if (head == null) 
			head = tail = newNode;
		else {
			newNode.next = head;
			head.prev = newNode;
			head = newNode;
		}
		size++;
	}

	
	public void add(D data) {
		Node<D> newNode = new Node<D>(data);
		if (head == null) {
			tail = head = newNode;
			size++;
		} else
			addLast(data);
	}

	public int size() {
		return size;
	}

	public String toString() {
		if (size > 0) {
			System.out.print("[");
			Node<D> temp = head;
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

	private class Node<D> {
		private D data;
		private Node<D> prev;
		private Node<D> next;

		public Node(D data) {
			this.data = data;
		}

		@Override
		public String toString() {
			return "Node [data=" + data + ", prev=" + prev + ", next=" + next + "]";
		}
	}
}// class
