--召喚獣メルカバー
--Merkabah the Eidolon Beast
--Scripted by Eerie Code
function c75286621.initial_effect(c)
	c:EnableReviveLimit()
	if Card.IsFusionAttribute then
		aux.AddFusionProcCodeFun(c,86120751,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT,c),1,true,true)
	else
		aux.AddFusionProcCodeFun(c,86120751,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),1,true,true)
	end
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c75286621.condition)
	e1:SetCost(c75286621.cost)
	e1:SetTarget(c75286621.target)
	e1:SetOperation(c75286621.activate)
	c:RegisterEffect(e1)
end

function c75286621.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c75286621.cfilter(c,ty)
	return c:IsType(ty) and c:IsAbleToGraveAsCost()
end
function c75286621.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ty=bit.band(re:GetActiveType(),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return Duel.IsExistingMatchingCard(c75286621.cfilter,tp,LOCATION_HAND,0,1,nil,ty) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75286621.cfilter,tp,LOCATION_HAND,0,1,1,nil,ty)
	Duel.SendtoGrave(g,REASON_COST)
end
function c75286621.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c75286621.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) then 
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
