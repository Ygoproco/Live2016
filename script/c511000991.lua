--Level Tax
function c511000991.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--affect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)	
	e2:SetOperation(c511000991.operation)
	c:RegisterEffect(e2)
	--30459350 chk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(511000991)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)
end
function c511000991.filter(c)
	return c:IsLevelAbove(5) and c:GetFlagEffect(511000991)==0
end
function c511000991.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c511000991.filter,0,0xff,0xff,nil,5)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SUMMON_COST)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCost(c511000991.costchk)
		e1:SetOperation(c511000991.costop)
		e1:SetReset(RESET_EVENT+0x1fe0001)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_FLIPSUMMON_COST)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SPSUMMON_COST)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e4:SetCode(EVENT_ADJUST)
		e4:SetRange(0xff)
		e4:SetOperation(c511000991.resetop)
		e4:SetReset(RESET_EVENT+0x1fe0001)
		tc:RegisterEffect(e4)
		tc:RegisterFlagEffect(511000991,RESET_EVENT+0x1fe0001,0,0)
		tc=g:GetNext()
	end
end
function c511000991.costchk(e,c,tp)
	local atk=c:GetAttack()
	e:SetLabel(atk)
	return Duel.CheckLPCost(c:GetControler(),atk)
end
function c511000991.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.PayLPCost(c:GetControler(),e:GetLabel())
	e:SetLabel(0)
end
function c511000991.resetop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,511000991) then
		e:GetHandler():ResetEffect(0x1,RESET_EVENT)
	end
end
