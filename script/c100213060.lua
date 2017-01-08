--エンタメデュエル
--Dueltainment
--Scripted by Eerie Code
function c100213060.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--on special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c100213060.spop)
	c:RegisterEffect(e2)
	--battled 5 times
	local e3=e2:Clone()
	e3:SetCode(EVENT_BATTLED)
	e3:SetOperation(c100213060.batop)
	c:RegisterEffect(e3)
	--on chain 5
	local e4=e2:Clone()
	e4:SetCode(EVENT_CHAINING)
	e4:SetOperation(c100213060.chainop)
	c:RegisterEffect(e4)
	--gambled 5 times
	local e5=e2:Clone()
	e5:SetCode(EVENT_CUSTOM+100213060)
	e5:SetOperation(c100213060.gamop)
	c:RegisterEffect(e5)
	--damage
	local e6=e2:Clone()
	e6:SetCode(EVENT_DAMAGE)
	e6:SetOperation(c100213060.damop)
	c:RegisterEffect(e6)
	--event counters
	if not c100213060.global_flag then
		c100213060.global_flag=true
		c100213060[0]=0
		c100213060[1]=0
		--Checks effects that make a player toss a coin or throw a dice
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c100213060.checkop)
		Duel.RegisterEffect(ge1,0)
		--Checks effects that allow a player to redo a coin toss or dice roll
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CUSTOM+100213060+100)
		ge2:SetOperation(c100213060.checkop2)
		Duel.RegisterEffect(ge2,0)
		--Counts the number of times a monster has battled
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_BATTLE_CONFIRM)
		ge3:SetOperation(c100213060.checkop3)
		Duel.RegisterEffect(ge3,0)
		--Reset at the start of the next Draw Phase
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetOperation(c100213060.clear)
		--Duel.RegisterEffect(ge0,0)
	end
end
function c100213060.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(0,CATEGORY_DICE)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(0,CATEGORY_COIN)
	if ex1 then
		if dp1==PLAYER_ALL then
			c100213060[0]=c100213060[0]+dv1
			c100213060[1]=c100213060[1]+dv1
		else
			c100213060[dp1]=c100213060[dp1]+dv1
		end
	end
	if ex2 then
		if dp2==PLAYER_ALL then
			c100213060[0]=c100213060[0]+dv2
			c100213060[1]=c100213060[1]+dv2
		else
			c100213060[dp2]=c100213060[dp2]+dv2
		end
	end
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+100213060,re,r,rp,0,0)
end
function c100213060.checkop2(e,tp,eg,ep,ev,re,r,rp)
	if ep==PLAYER_ALL then
		c100213060[0]=c100213060[0]+ev
		c100213060[1]=c100213060[1]+ev
	else
		c100213060[ep]=c100213060[ep]+ev
	end
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+100213060,re,r,rp,0,0)
end
function c100213060.checkop3(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	a:RegisterFlagEffect(100213060,RESET_EVENT+0x1fe0000,0,1)
	if d then d:RegisterFlagEffect(100213060,RESET_EVENT+0x1fe0000,0,1) end
end
function c100213060.clear(e,tp,eg,ep,ev,re,r,rp)
	c100213060[0]=0
	c100213060[1]=0
end
--Utility to avoid repeating the same lines of code 5 times
function c100213060.draw_op(e,p,flag)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.Draw(p,2,REASON_EFFECT)
	e:GetHandler():RegisterFlagEffect(flag+p,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c100213060.spop(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return end
	for p=0,1 do
		if e:GetHandler():GetFlagEffect(100213060+p)==0 then
			if eg:Filter(Card.IsControler,nil,p):GetClassCount(Card.GetLevel)==5 then
				c100213060.draw_op(e,p,100213060)
			end
		end
	end
end
function c100213060.batop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=nil
	if d then g=Group.FromCards(a,d) else g=Group.FromCards(a) end
	local tc=g:GetFirst()
	while tc do
		local p=tc:GetControler()
		if tc:GetFlagEffect(100213060)==5 and e:GetHandler():GetFlagEffect(100213160+p)==0 then
			c100213060.draw_op(e,p,100213160)
		end
		tc=g:GetNext()
	end
end
function c100213060.chainop(e,tp,eg,ep,ev,re,r,rp)
	local ch=Duel.GetCurrentChain()
	if ch>=5 and e:GetHandler():GetFlagEffect(100213260+rp)==0 then
		c100213060.draw_op(e,rp,100213260)
	end
end
function c100213060.gamop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if e:GetHandler():GetFlagEffect(100213360+p)==0 and c100213060[p]==5 then
			c100213060.draw_op(e,p,100213360)
		end
	end
end
function c100213060.damop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if (ep==p or ep==PLAYER_ALL) and Duel.GetLP(p)<=500
			and e:GetHandler():GetFlagEffect(100213460+p)==0 then
			c100213060.draw_op(e,p,100213460)
		end
	end
end