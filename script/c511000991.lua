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
end
function c511000991.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local wg=Duel.GetMatchingGroup(Card.IsLevelAbove,c:GetControler(),0xFF,0xFF,nil,5)
	local wbc=wg:GetFirst()
	while wbc do
		if wbc:GetFlagEffect(511000991)==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SUMMON_COST)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCost(c511000991.costchk)
			e1:SetOperation(c511000991.costop)
			e1:SetReset(RESET_EVENT+0x1fe0000+EVENT_ADJUST,1)
			wbc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_FLIPSUMMON_COST)
			wbc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_SPSUMMON_COST)
			wbc:RegisterEffect(e3)
			wbc:RegisterFlagEffect(511000991,RESET_EVENT+0x1fe0000+EVENT_ADJUST,0,1) 	
		end	
		wbc=wg:GetNext()
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
