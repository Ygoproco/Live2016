--Numeron Network
function c511000275.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--activate opponent's turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511000275,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_DRAW)
	e2:SetProperty(EFFECT_FLAG_REPEAT)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(c511000275.accon)
	e2:SetTarget(c511000275.actg)
	e2:SetOperation(c511000275.acop)
	c:RegisterEffect(e2)
	--no remove overlay
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511000275,1))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c511000275.rcon)
	c:RegisterEffect(e3)
	--activate opponent's turn
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12079734,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(c511000275.numcon)
	e4:SetTarget(c511000275.numtg)
	e4:SetOperation(c511000275.numop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(27346636,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCondition(c511000275.numcon)
	e5:SetTarget(c511000275.numtg)
	e5:SetOperation(c511000275.numop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(93016201,0))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_SPSUMMON)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e6:SetCondition(c511000275.numcon)
	e6:SetTarget(c511000275.numtg)
	e6:SetOperation(c511000275.numop)
	c:RegisterEffect(e6)
end
function c511000275.accon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_ONFIELD,0)==0
end
function c511000275.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end	
end
function c511000275.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.RaiseEvent(c,EVENT_CHAIN_SOLVED,c:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
	end
end
function c511000275.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:GetHandler():IsType(TYPE_XYZ) and ep==e:GetOwnerPlayer() and re:GetHandler():GetOverlayCount()>=ev-1
	and re:GetHandler():IsSetCard(0x1FF)
end
function c511000275.numcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_ONFIELD,0)==1
end
function c511000275.tgfilter(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
	if not c:IsSetCard(0x1ff) or not c:IsAbleToGrave() or not te then return end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	if (te:GetCode()==EVENT_FREE_CHAIN and e:GetCode()==EVENT_FREE_CHAIN) 
		or (te:GetCode()==EVENT_CHAINING and e:GetCode()==EVENT_CHAINING) 
		or (te:GetCode()==EVENT_SPSUMMON and e:GetCode()==EVENT_SPSUMMON) then
		return (not condition or condition(e,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0))
			and (not target or target(e,tp,eg,ep,ev,re,r,rp,0))
	else
		return false
	end
end
function c511000275.numtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511000275.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c511000275.numop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c511000275.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local te=tc:GetActivateEffect()
		e:SetLabelObject(te)
		Duel.ClearTargetCard()
		local cost=te:GetCost()
		if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
		local tg=te:GetTarget()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
