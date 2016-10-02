--創星神 ｔｉｅｒｒａ
--Tierra, Goddess of Rebirth
--Scripted by Eerie Code
function c7527.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c7527.spcon)
	e1:SetOperation(c7527.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(7527,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(c7527.tdtg)
	e4:SetOperation(c7527.tdop)
	c:RegisterEffect(e4)
end

function c7527.spfil(c)
	return c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function c7527.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c7527.spfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	return g:GetClassCount(Card.GetCode)>=10
end
function c7527.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c7527.spfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	local g=Group.CreateGroup()
	for i=1,10 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=mg:Select(tp,1,1,nil)
		local cd=sg:GetFirst():GetCode()
		g:Merge(sg)
		mg:Remove(Card.IsCode,nil,cd)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

function c7527.tdfil(c)
	return c:IsAbleToDeck() and ((c:IsFaceup() and c:IsType(TYPE_PENDULUM)) or not c:IsLocation(LOCATION_EXTRA))
end
function c7527.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c7527.tdfil,tp,0x5e,0x5e,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c7527.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c7527.tdfil,tp,0x5e,0x5e,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
