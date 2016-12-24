--幻煌龍の戦禍
--Clashing Whirlpool of the Mythic Radiance Dragon
--Script by dest
function c100912072.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c100912072.condition)
	e1:SetTarget(c100912072.target)
	e1:SetOperation(c100912072.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c100912072.handcon)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100912072,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c100912072.eqcost)
	e3:SetTarget(c100912072.eqtg)
	e3:SetOperation(c100912072.eqop)
	c:RegisterEffect(e3)
end
function c100912072.cfilter(c)
	return c:IsFacedown() or not c:IsType(TYPE_NORMAL)
end
function c100912072.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c100912072.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100912072.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100912072.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c100912072.filter(c)
	return c:IsFaceup() and c:IsCode(22702055)
end
function c100912072.handcon(e)
	return Duel.IsExistingMatchingCard(c100912072.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(22702055)
end
function c100912072.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100912072.efilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsCanBeEffectTarget(e)
end
function c100912072.eqfilter(c,g)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsSetCard(0x1fc) and g:IsExists(c100912072.eqcheck,1,nil,c)
end
function c100912072.eqcheck(c,ec)
	return ec:CheckEquipTarget(c)
end
function c100912072.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c100912072.efilter,tp,LOCATION_MZONE,0,nil,e)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c100912072.efilter(chkc,e) end
	if chk==0 then return g:GetCount()>0 and Duel.IsExistingMatchingCard(c100912072.eqfilter,tp,LOCATION_SZONE,0,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100912072.efilter,tp,LOCATION_MZONE,0,1,1,nil,e)
end
function c100912072.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c100912072.eqfilter,tp,LOCATION_SZONE,0,nil,tg)
	local eq=g:GetFirst()
	while eq do
		Duel.Equip(tp,eq,tc,true,true)
		eq=g:GetNext()
	end
	Duel.EquipComplete()
end