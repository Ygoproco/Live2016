--破壊竜ガンドラ－ギガ・レイズ
--Gandora Giga Rays the Dragon of Destruction
--Scripted by Eerie Code
function c100200125.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c100200125.hspcon)
	e1:SetOperation(c100200125.hspop)
	c:RegisterEffect(e1)
	--atk gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetValue(c100200125.value)
	c:RegisterEffect(e2)
	--variable effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100200125,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c100200125.cost)
	e3:SetTarget(c100200125.target)
	e3:SetOperation(c100200125.operation)
	c:RegisterEffect(e3)
end
function c100200125.hspfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c100200125.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local num=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c100200125.hspfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,c)
	return g:GetCount()>=2 and num>=0 and (num>0 or g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>0)
end
function c100200125.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local num=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if num<0 then return end
	local hc=2
	local g=Duel.GetMatchingGroup(c100200125.hspfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,c)
	local sg=Group.CreateGroup()
	if num==0 then
		local sg1=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
		sg:Merge(sg1)
		g:RemoveCard(sg1:GetFirst())
		hc=1
	end
	local sg2=g:Select(tp,hc,hc,nil)
	sg:Merge(sg2)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c100200125.value(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED)*300
end
function c100200125.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c100200125.filter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x1fa) or c:IsCode(64681432,71525232))
end
function c100200125.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local gc=Duel.GetMatchingGroup(c100200125.filter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	if chk==0 then
		if gc==0 then return false end
		if gc==1 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
		if gc==2 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
		return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,c)
	end
	if gc==1 then
		e:SetCategory(CATEGORY_DESTROY)
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	else
		e:SetCategory(CATEGORY_REMOVE)
		local loc=LOCATION_ONFIELD
		if gc>2 then loc=LOCATION_ONFIELD+LOCATION_GRAVE end
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,loc,loc,c)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	end
end
function c100200125.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gc=Duel.GetMatchingGroup(c100200125.filter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	if gc==1 then
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
		Duel.Destroy(g,REASON_EFFECT)
	else
		local loc=LOCATION_ONFIELD
		if gc>2 then loc=LOCATION_ONFIELD+LOCATION_GRAVE end
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,loc,loc,c)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end