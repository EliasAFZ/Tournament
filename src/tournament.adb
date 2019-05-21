-- Name: Elias Afzalzada
-- Email: eafzalzada@radford.edu
-- Course: Itec 320
-- Homework #: 7
-- Link: https://www.radford.edu/~itec320//2018fall-ibarland/Homeworks/tournament/
-- Purpose: A game with player fighting each other using Queue's, Stacks and ADT's

with ada.Text_IO; use Ada.Text_IO;
with ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with ada.Text_IO.Unbounded_IO; use ada.Text_IO.Unbounded_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with queues;
with stacks;
with Ada.Characters.Latin_1;

procedure Tournament is

   -- player records holding all related information on a player
   type player is record
      arrivalNumber: natural;
      name: Unbounded_String;
      skillLevel: Natural;
      age: Natural;
      wins: Natural;
      losses: Natural;
   end record;

   -- player pointer which accesses player records
   type playerPtr is access player;

   -- print procedure packages
   procedure printPly(player: playerPtr) is
   begin
      Put(player.all.arrivalNumber);
      Put(player.all.age);
      Put(player.all.skillLevel);
      Put(player.all.wins);
      Put(player.all.losses);
      Put("    ");
      Put_Line(player.all.name);
   end printPly;

   --packages to use queues and stacks
   package quePak is new queues (ItemType => playerPtr, print => printPly);
   use quePak;
   package stackPak is new stacks (ItemType => playerPtr, print => printPly);
   use stackPak;

   --trim spaces out input
   function Trim (s : String) return String is
      space: Character := Ada.Characters.Latin_1.Space;
      lChar: Natural := s'First;
      rChar: Natural := s'Last;
   begin
      while (lChar < s'Last) and then (s(lChar)=space) loop
         lChar := Natural'Succ(lChar);
      end loop;
      while (rChar > s'First) and then (s(rChar)=space) loop
         rChar := Natural'Pred(rChar);
      end loop;
      return s(lChar..rChar);
   end Trim;

   -- procedure to get input from file and enqueue into first contender line
   procedure getInput(contenderLine: in out Queue) is
      arrivalNumber: Natural := 1;
      nameTmp: Unbounded_String;
      skillLevelTmp: Natural;
      ageTmp: Natural;
   begin
      while not End_Of_File loop
         Get_Line(nameTmp);
         nameTmp := To_Unbounded_String(trim(To_String(nameTmp)));
         Get(skillLevelTmp);
         Get(ageTmp);
         Skip_Line;
         quePak.enqueue(new player'(arrivalNumber, nameTmp, skillLevelTmp,
                        ageTmp, 0, 0), contenderLine);
         arrivalNumber := arrivalNumber + 1;
      end loop;
   end getInput;

   -- print procedure for printing winners stack out in correct order
   procedure printOutput(q: in out Queue)is
      winnersOrdered: Stack;
      tmpPtr: playerPtr;
   begin
      while(quePak.size(q) > 0) loop
         tmpPtr := quePak.front(q);
         quePak.dequeue(q);
         stackPak.push(tmpPtr, winnersOrdered);
      end loop;
      Put_Line("       Number       Age       Skill      Wins      Losses  Name");
      stackPak.print(winnersOrdered);
   end printOutput;

   -- Processes battles between players based on conditions
   procedure processBattle(contenderLine: in out Queue; runnerUpLine: in out
                             Queue) is
      player1: playerPtr;
      player2: playerPtr;
   begin
      player1 := quePak.front(contenderLine);
      quePak.dequeue(contenderLine);
      player2 := quePak.front(contenderLine);
      quePak.dequeue(contenderLine);

      -- skill level win condition
      if(player1.all.skillLevel > player2.all.skillLevel) then
         player1.all.wins := player1.all.wins + 1;
         player2.all.losses := player2.all.losses + 1;
         quePak.enqueue(player1, contenderLine);
         quePak.enqueue(player2, runnerUpLine);

      elsif(player1.all.skillLevel < player2.all.skillLevel) then
         player2.all.wins := player2.all.wins + 1;
         player1.all.losses := player1.all.losses + 1;
         quePak.enqueue(player2, contenderLine);
         quePak.enqueue(player1, runnerUpLine);

      elsif(player1.all.skillLevel = player2.all.skillLevel) then
         -- wiser age win condition
         if(player1.all.age > player2.all.age) then
            player1.all.wins := player1.all.wins + 1;
            player2.all.losses := player2.all.losses + 1;
            quePak.enqueue(player1, contenderLine);
            quePak.enqueue(player2, runnerUpLine);

         elsif(player1.all.age < player2.all.age) then
            player2.all.wins := player2.all.wins + 1;
            player1.all.losses := player1.all.losses + 1;
            quePak.enqueue(player2, contenderLine);
            quePak.enqueue(player1, runnerUpLine);

         elsif(player1.all.age = player2.all.age) then
            -- amount of wins, win condition
            if(player1.all.wins > player2.all.wins) then
               player1.all.wins := player1.all.wins + 1;
               player2.all.losses := player2.all.losses + 1;
               quePak.enqueue(player1, contenderLine);
               quePak.enqueue(player2, runnerUpLine);

            elsif(player1.all.wins < player2.all.wins) then
               player2.all.wins := player2.all.wins + 1;
               player1.all.losses := player1.all.losses + 1;
               quePak.enqueue(player2, contenderLine);
               quePak.enqueue(player1, runnerUpLine);

            elsif(player1.all.wins = player2.all.wins) then
               -- amount of losses win condition
               if(player1.all.losses < player2.all.losses) then
                  player1.all.wins := player1.all.wins + 1;
                  player2.all.losses := player2.all.losses + 1;
                  quePak.enqueue(player1, contenderLine);
                  quePak.enqueue(player2, runnerUpLine);

               elsif(player1.all.losses > player2.all.losses) then
                  player2.all.wins := player2.all.wins + 1;
                  player1.all.losses := player1.all.losses + 1;
                  quePak.enqueue(player2, contenderLine);
                  quePak.enqueue(player1, runnerUpLine);

               elsif(player1.all.losses = player2.all.losses) then
                  -- first to arrive win condition
                  if(player1.all.arrivalNumber < player2.all.arrivalNumber) then
                     player1.all.wins := player1.all.wins + 1;
                     player2.all.losses := player2.all.losses + 1;
                     quePak.enqueue(player1, contenderLine);
                     quePak.enqueue(player2, runnerUpLine);

                  elsif(player1.all.arrivalNumber > player2.all.arrivalNumber)
                  then
                     player2.all.wins := player2.all.wins + 1;
                     player1.all.losses := player1.all.losses + 1;
                     quePak.enqueue(player2, contenderLine);
                     quePak.enqueue(player1, runnerUpLine);

                  end if;
               end if;
            end if;
         end if;
      end if;
   end processBattle;

   -- Puts winners in winner queue after fights results are determined
   procedure processWinner(contenderLine: in out Queue; runnerUpLine: in out
                             Queue; winnersUnordered: in out Queue) is
      winner: playerPtr;
   begin
      -- checks special condition of only one player
      if(quepak.size(contenderLine) = 1) then
         winner := quePak.front(contenderLine);
         quePak.dequeue(contenderLine);
         quepak.enqueue(winner, winnersUnordered);
      end if;

      while(quePak.size(contenderLine) >  quePak.size(winnersUnordered)) loop
         while(quePak.size(contenderLine) > 1) loop
            processBattle(contenderLine, runnerUpLine);
         end loop;
         winner := quePak.front(contenderLine);
         quePak.dequeue(contenderLine);
         quePak.enqueue(winner, winnersUnordered);

         while(quePak.size(runnerUpLine) > 1) loop
            processBattle(runnerUpLine, contenderLine);
         end loop;
         winner := quePak.front(runnerUpLine);
         quePak.dequeue(runnerUpLine);
         quePak.enqueue(winner, winnersUnordered);

         -- checks condition if only one player left
         if(quepak.size(contenderLine) = 1) then
            winner := quePak.front(contenderLine);
            quePak.dequeue(contenderLine);
            quepak.enqueue(winner, winnersUnordered);
         end if;
      end loop;
   end processWinner;

   -- Battle line queues to sort player current positions in tournament
   contenderLine: Queue;
   runnerUpLine: Queue;
   winnersUnOrdered: Queue;
begin
   getInput(contenderLine);
   processWinner(contenderLine, runnerUpLine, winnersUnOrdered);
   printOutput(winnersUnOrdered);
end Tournament;
