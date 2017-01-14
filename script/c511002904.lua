--Automatic Gearspring Machine
function c511002904.initial_effect(c)
	c:EnableCounterPermit(0x107)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511002904.target)
	e1:SetOperation(c511002904.activate)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c511002904.ctcon)
	e2:SetOperation(c511002904.ctop)
	c:RegisterEffect(e2)
	--place
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetDescription(aux.Stringid(47408488,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c511002904.plcost)
	e4:SetTarget(c511002904.pltg)
	e4:SetOperation(c511002904.plop)
	c:RegisterEffect(e4)
end
function c511002904.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x107)
end
function c511002904.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x107,2)
		Duel.RaiseEvent(c,511002905,e,REASON_EFFECT,tp,tp,0x107)
	end
end
function c511002904.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c511002904.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x107,1)
	Duel.RaiseSingleEvent(c,511002905,e,0,0,tp,0)
end
function c511002904.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	e:SetLabel(e:GetHandler():GetCounter(0x107))
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c511002904.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local ct=c:GetCounter(0x107)
		return ct>0 and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,0x107,ct)
	end
	Duel.SetTargetParam(e:GetLabel())
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0x107)
end
function c511002904.plop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(73853830,1))
	local g=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,0x107,ct)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		tc:AddCounter(0x107,ct)
		Duel.RaiseEvent(tc,511002905,e,REASON_EFFECT,tp,tp,0x107)
	end
end
