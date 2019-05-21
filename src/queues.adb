with ada.Text_IO; use Ada.Text_IO;
with Unchecked_Deallocation;

package body queues is

   procedure free is new Unchecked_Deallocation (object => QueueNode, Name => QueueNodePointer);

   function is_Empty(q: Queue) return Boolean is
   begin
      return q.Count = 0;
   end is_Empty;

   function size(q: Queue) return Natural is
   begin
      return q.Count;
   end size;

   function front(q: Queue) return ItemType is
   begin
      return q.Front.all.data;
   end front;

   function  is_Full(q: Queue) return Boolean is
       tmpPtr : QueueNodePointer;
   begin
      tmpPtr := new QueueNode;
        free(tmpPtr);
        return False;
    exception
        when STORAGE_ERROR =>
            return TRUE;
   end is_full;

   procedure Enqueue (item: ItemType; q: in out Queue) is
   begin
      if(q.Back = null or q.Front = null) then
         q.Back := new QueueNode'(item, null);
         q.Front := q.Back;
         q.Count := q.Count + 1;
      else
         q.Back.all.next := new QueueNode'(item, null);
         q.Back := q.Back.all.next;
         q.Count := q.Count + 1;
      end if;
   end Enqueue;

   procedure print(q: in Queue) is
      tmpPtr: QueueNodePointer := q.Front;
   begin
      while (tmpPtr /= null) loop
         print(tmpPtr.all.Data);
         tmpPtr := tmpPtr.all.Next;
      end loop;
   end print;

   procedure Dequeue (q: in out Queue) is
   begin
      if is_Empty(q) then
         raise Queue_Empty;
      else
         q.Front := q.Front.all.next;
         q.Count := q.Count - 1;
      end if;
   end Dequeue;
end queues;
