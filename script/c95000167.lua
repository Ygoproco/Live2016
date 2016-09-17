--Action Field - The Gates of Dark World
function c95000167.initial_effect(c)
	--Activate	
	local e1=Effect.CreateEffect(c)	
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1,95000167+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(0xff)
	e1:SetOperation(c95000167.op)
	c:RegisterEffect(e1)
	--unaffectable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c95000167.ctcon2)
	c:RegisterEffect(e3)
	--cannot set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c95000167.aclimit2)
	c:RegisterEffect(e4)
	--cannot activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetTargetRange(1,1)
	e5:SetValue(c95000167.aclimit)
	c:RegisterEffect(e5)
	--~ Add Action Card
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(95000167,0))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCondition(c95000167.condition)
	e6:SetTarget(c95000167.Acttarget)
	e6:SetOperation(c95000167.operation)
	c:RegisterEffect(e6)
	--cannot change zone
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_SINGLE)
	eb:SetCode(EFFECT_CANNOT_TO_DECK)
	eb:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	eb:SetRange(LOCATION_SZONE)
	c:RegisterEffect(eb)
	local ec=eb:Clone()
	ec:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(ec)
	local ed=eb:Clone()
	ed:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(ed)
	local ee=eb:Clone()
	ee:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(ee)
	--cheater check
	local ef=Effect.CreateEffect(c)	
	ef:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ef:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ef:SetCode(EVENT_PREDRAW)
	ef:SetCountLimit(1)
	ef:SetRange(0xff)
	ef:SetOperation(c95000167.Cheatercheck1)
	c:RegisterEffect(ef)
	-- Draw when removed
	local ef3=Effect.CreateEffect(c)
	ef3:SetDescription(aux.Stringid(44792253,0))
	ef3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ef3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ef3:SetCode(EVENT_REMOVE)
	ef3:SetCondition(c95000167.descon)
	ef3:SetTarget(c95000167.drtarget)
	ef3:SetOperation(c95000167.drop)
	c:RegisterEffect(ef3)
	
		--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FIEND))
	e2:SetValue(150)
	c:RegisterEffect(e2)
	--defup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FIEND))
	e3:SetValue(150)
	c:RegisterEffect(e3)
	--discard & draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e4:SetDescription(aux.Stringid(33017655,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c95000167.cost)
	e4:SetTarget(c95000167.target)
	e4:SetOperation(c95000167.operation)
	c:RegisterEffect(e4)
end
function c95000167.Cheatercheck1(e,c)
	if Duel.GetMatchingGroupCount(c95000167.Fieldfilter,tp,0,LOCATION_DECK+LOCATION_HAND,nil)>1
	then
	local WIN_REASON_ACTION_FIELD=0x55
	Duel.Win(tp,WIN_REASON_ACTION_FIELD)
	end
	
	local sg=Duel.GetMatchingGroup(c95000167.Fieldfilter,tp,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end

function c95000167.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c95000167.drtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c95000167.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_RULE)
end
function c95000167.Fieldfilter(c)
	return c:IsSetCard(0xac2)
end
function c95000167.ctcon2(e,re)
	return re:GetHandler()~=e:GetHandler()
end
function c95000043.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c95000167.aclimit2(e,c)
	return c:IsType(TYPE_FIELD)
end
function c95000167.tgn(e,c)
	return c==e:GetHandler()
end
function c95000167.op(e,tp,eg,ep,ev,re,r,rp,chk)
local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local tc2=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)	
	if tc==nil then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		if tc2==nil then
			local token=Duel.CreateToken(tp,95000167,nil,nil,nil,nil,nil,nil)		
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			token:RegisterEffect(e1)
			Duel.MoveToField(token,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
		end
	end
	-- if e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
		-- Duel.Draw(tp,1,REASON_RULE)
	-- end
end
-- Add Action Card
function c95000167.Acttarget(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
Duel.Hint(HINT_SELECTMSG,tp,564)
if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then
local g=Duel.GetDecktopGroup(tp,1)
local tc=g:GetFirst()
math.randomseed( tc:getcode() )
end
i = math.random(20)
ac=math.random(1,tableAction_size)
e:SetLabel(tableAction[ac])
end
function c95000167.operation(e,tp,eg,ep,ev,re,r,rp)
if Duel.SelectYesNo(1-tp,aux.Stringid(95000167,0)) then
local dc=Duel.TossDice(tp,1)
if dc==2 or dc==3 or dc==4 or dc==6 then
e:GetHandler():RegisterFlagEffect(95000167,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
if dc==1 or dc==2 then
if not Duel.IsExistingMatchingCard(c95000167.cfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil) then
		local token=Duel.CreateToken(tp,e:GetLabel(),nil,nil,nil,nil,nil,nil)		
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_QUICKPLAY)
		token:RegisterEffect(e1)
		Duel.SendtoHand(token,nil,REASON_EFFECT)
		Duel.SpecialSummonComplete()	
end
end

if dc==5 or dc==6 then
 if not Duel.IsExistingMatchingCard(c95000167.cfilter,1-tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil) then
		local token=Duel.CreateToken(1-tp,e:GetLabel(),nil,nil,nil,nil,nil,nil)		
		Duel.SpecialSummonStep(token,0,1-tp,1-tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_QUICKPLAY)
		token:RegisterEffect(e1)
		Duel.SendtoHand(token,1-tp,REASON_EFFECT)
		Duel.SpecialSummonComplete()
		end

end

else 
if not Duel.IsExistingMatchingCard(c95000167.cfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil) then
		local token=Duel.CreateToken(tp,e:GetLabel(),nil,nil,nil,nil,nil,nil)		
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_QUICKPLAY)
		token:RegisterEffect(e1)
		Duel.SendtoHand(token,nil,REASON_EFFECT)
		Duel.SpecialSummonComplete()	
end
end
end
function c95000167.aclimit2(e,c)
	return c:IsType(TYPE_FIELD)
end
function c95000167.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c95000167.cfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil) and e:GetHandler():GetFlagEffect(95000167)==0
	and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c95000167.cfilter(c)
	return c:IsSetCard(0xac1)
end
tableAction = {
95000044,
95000045,
95000046,
95000143
} 
tableAction_size=4

function c95000167.costfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToRemoveAsCost()
end
function c95000167.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95000167.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c95000167.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c95000167.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_HAND,0,1,nil,RACE_FIEND)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c95000167.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_HAND,0,1,1,nil,RACE_FIEND)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
