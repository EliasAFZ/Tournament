with ada.Text_IO; use Ada.Text_IO;
with Unchecked_Deallocation;

package body stacks is

   procedure free is new Unchecked_Deallocation (object => StackNode, Name => Stack);

   function  is_Empty(s: Stack) return Boolean is
   begin
      return s = null;
   end is_Empty;

   function Is_Full (s: Stack) return boolean is
      tmpPtr: Stack;
   begin
      tmpPtr := new StackNode;
      free(tmpPtr);
      return false;
   exception
      when Storage_Error => return true;
   end Is_Full;

   procedure Push(item: ItemType; s: in out Stack) is
      newStackTop: stack := new StackNode'(item, null);
   begin
      if(s = null) then
         s := newStackTop;
      else
         newStackTop.all.Next := s;
         s := newStackTop;
      end if;
   end push;

   procedure Pop(s: in out Stack) is
   begin
      s:= s.all.next;
   end Pop;

   function Top(s: Stack) return ItemType is
   begin
      return s.all.Item;
   end Top;

   procedure print(s: in Stack) is
      tmpStack: Stack := s;
   begin
      while(tmpStack /= null) loop
         print(tmpStack.all.Item);
         tmpStack := tmpStack.all.Next;
      end loop;
   end print;
end stacks;
