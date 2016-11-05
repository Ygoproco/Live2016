--召喚獣メルカバー
--Merkabah the Eidolon Beast
--Scripted by Eerie Code
function c7632.initial_effect(c)
	c:EnableReviveLimit()
	if Card.IsFusionAttribute then
		aux.AddFusionProcCodeFun(c,7626,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT),1,true,true)
	else
		aux.AddFusionProcCodeFun(c,7626,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),1,true,true)
	end
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c7632.condition)
	e1:SetCost(c7632.cost)
	e1:SetTarget(c7632.target)
	e1:SetOperation(c7632.activate)
	c:RegisterEffect(e1)
end

function c7632.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c7632.cfilter(c,type)
	return c:IsType(type) and c:IsAbleToGraveAsCost()
end
function c7632.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local type=re:GetActiveType()
	if chk==0 then return Duel.IsExistingMatchingCard(c7632.cfilter,tp,LOCATION_HAND,0,1,nil,type) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c7632.cfilter,tp,LOCATION_HAND,0,1,1,nil,type)
	Duel.SendtoGrave(g,REASON_COST)
end
function c7632.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c7632.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) then 
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
