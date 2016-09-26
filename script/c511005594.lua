--mistrust
--scripted by GameMaster (GM) and Snrk
function c511005594.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c511005594.target)
	e2:SetOperation(c511005594.operation)
	c:RegisterEffect(e2)
end
function c511005594.filter(c,e,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsControlerCanBeChanged()
end
function c511005594.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return eg:IsExists(c511005594.filter,1,nil,e,1-tp) end
end
function c511005594.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc
	local c=e:GetHandler()
	local g=eg:Filter(c511005594.filter,nil,e,1-tp)
	if g:GetCount()<1 or not c:IsRelateToEffect(e) then return end
	if g:GetCount()>1 then tc=g:Select(tp,1,1,nil) else tc=g:GetFirst() end
	if tc then Duel.GetControl(tc,tp) end
end